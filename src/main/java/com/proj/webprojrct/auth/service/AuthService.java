package com.proj.webprojrct.auth.service;

import java.io.IOException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import com.proj.webprojrct.sms.speedSMsService;
import com.proj.webprojrct.email.emailService;

import com.proj.webprojrct.common.config.security.PasswordConfig;
import com.proj.webprojrct.auth.repository.OtpCodeRepository;

import com.proj.webprojrct.common.config.security.JwtUtil;

import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.user.repository.UserRepository;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.proj.webprojrct.auth.dto.request.ChangePassRequest;
import com.proj.webprojrct.auth.dto.request.RegisterRequest;
import com.proj.webprojrct.auth.entity.OtpCode;

import com.proj.webprojrct.auth.mapper.AuthMapper;

import com.proj.webprojrct.auth.dto.request.RegisterRequest;
import com.proj.webprojrct.auth.mapper.*;
import com.proj.webprojrct.auth.dto.response.LoginResponse;
import com.proj.webprojrct.auth.entity.OtpCode;
import com.proj.webprojrct.auth.entity.OtpType;
import com.proj.webprojrct.common.config.security.CustomUserDetails;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import com.proj.webprojrct.common.config.logging.SecurityEventLogger;
import com.proj.webprojrct.common.config.metrics.LoginMetrics;
import com.proj.webprojrct.common.util.HtmlSanitizer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@AllArgsConstructor
@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);

    private final OtpCodeRepository otpCodeRepository;
    private final AuthMapper authMapper;
    private final AuthenticationManager authManager;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final speedSMsService sSms;
    private final emailService emailService;
    private final JwtUtil jwtUtil;
    // [LOGGING/MONITORING] Custom Prometheus metrics bean - OWASP A09
    private final LoginMetrics loginMetrics;

    public LoginResponse handleLogin(String phone, String password, HttpSession session, Model model) throws Exception {

        try {
            Authentication auth = authManager.authenticate(
                    new UsernamePasswordAuthenticationToken(phone, password));

            CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
            User user = userDetails.getUser();

            if (user == null || !user.getIsActive()) {
                throw new RuntimeException("Tài khoản không tồn tại hoặc đã bị khoá.");
            }

            String accessToken = jwtUtil.generateAccessToken(user);
            String refreshToken = jwtUtil.generateRefreshToken(user);

            // LÆ°u refresh token vÃ o DB
            user.setRefreshToken(refreshToken);
            userRepository.save(user);

            // [LOGGING] Ghi log đăng nhập thành công kèm role - OWASP A09
            // Admin/Seller login ghi mức WARN để nổi bật trong log
            SecurityEventLogger.loginSuccess(phone, getClientIp(), user.getRole().name());
            // [METRICS] Tăng counter Prometheus
            loginMetrics.recordLoginSuccess();

            return new LoginResponse(user, accessToken, refreshToken);
        } catch (org.springframework.security.authentication.DisabledException e) {
            model.addAttribute("error",
                    "Tài khoản đã bị vô hiệu hoá. Vui lòng liên hệ quản trị viên.");
            throw new RuntimeException(
                    "Tài khoản đã bị vô hiệu hoá. Vui lòng liên hệ quản trị viên.");
        } catch (BadCredentialsException e) {
            model.addAttribute("error", "Sai số điện thoại hoặc mật khẩu!");
            throw new RuntimeException("Sai số điện thoại hoặc mật khẩu!");
        }
    }

    /**
     * [LOGGING HELPER] Lấy IP thực của client, hỗ trợ reverse proxy
     * (X-Forwarded-For).
     * Dùng RequestContextHolder để truy cập request từ service layer.
     */
    private String getClientIp() {
        try {
            ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs != null) {
                HttpServletRequest request = attrs.getRequest();
                String xForwardedFor = request.getHeader("X-Forwarded-For");
                if (xForwardedFor != null && !xForwardedFor.isBlank()) {
                    return xForwardedFor.split(",")[0].trim();
                }
                return request.getRemoteAddr();
            }
        } catch (Exception ignored) {
            // Không thể lấy IP => trả về unknown, không được throw exception
            log.debug("Không thể lấy client IP", ignored);
        }
        return "unknown";
    }

    public void validateRegisterRequest(RegisterRequest request) {
        // Validate password
        if (!isValidPassword(request.getPassword())) {
            throw new RuntimeException(
                    "Mật khẩu phải có ít nhất 12 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (!@#$%...)!");
        }

        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new RuntimeException("Mật khẩu và xác nhận mật khẩu không khớp!");
        }

        // Validate phone (10 digits)
        if (!isValidPhone(request.getPhone())) {
            throw new RuntimeException("Số điện thoại phải có đúng 10 chữ số!");
        }

        if (userRepository.existsByPhone(request.getPhone())) {
            throw new RuntimeException("Số điện thoại đã được đăng ký!");
        }

        // Validate email
        if (!isValidEmail(request.getEmail())) {
            throw new RuntimeException("Email không hợp lệ!");
        }

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email đã được đăng ký!");
        }
    }

    /**
     * Tạo user sau khi OTP đã được xác thực
     */
    public User createUserFromRegistration(RegisterRequest request) {
        // [XSS-FIX] Sanitize user input trước khi lưu DB
        request.setFullName(HtmlSanitizer.sanitize(request.getFullName()));
        request.setAddress(HtmlSanitizer.sanitize(request.getAddress()));
        User user = authMapper.toEntity(request);
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setRole(UserRole.USER);
        user.setVerifyPhone(true); // Đã xác thực OTP
        return userRepository.save(user);
    }

    public User registerUser(RegisterRequest request) {
        // Validate password
        if (!isValidPassword(request.getPassword())) {
            throw new RuntimeException(
                    "Mật khẩu phải có ít nhất 12 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (!@#$%...)!");
        }
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new RuntimeException("Mật khẩu và xác nhận mật khẩu không khớp!");
        }
        // Validate phone (10 digits)
        if (!isValidPhone(request.getPhone())) {
            throw new RuntimeException("Số điện thoại phải có đúng 10 chữ số!");
        }
        if (userRepository.existsByPhone(request.getPhone())) {
            throw new RuntimeException("Số điện thoại đã được đăng ký!");
        }
        // Validate email
        if (!isValidEmail(request.getEmail())) {
            throw new RuntimeException("Email không hợp lệ!");
        }
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email đã được đăng ký!");
        }
        // [XSS-FIX] Sanitize user input trước khi lưu DB
        request.setFullName(HtmlSanitizer.sanitize(request.getFullName()));
        request.setAddress(HtmlSanitizer.sanitize(request.getAddress()));
        User user = authMapper.toEntity(request);
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setRole(UserRole.USER);
        User saved = userRepository.save(user);
        // [LOGGING] Ghi log đăng ký thành công - OWASP A09
        SecurityEventLogger.registerSuccess(request.getPhone(), getClientIp());
        loginMetrics.recordRegister();
        return saved;
    }

    public User handleRefreshToken(String refreshToken) {
        // Lấy username từ refresh token
        String username = jwtUtil.extractUsername(refreshToken);

        User user = userRepository.findByPhone(username)
                .orElseThrow(() -> new RuntimeException("User không tồn tại"));

        // So sánh với refresh token trong DB
        if (!refreshToken.equals(user.getRefreshToken())) {
            throw new RuntimeException("Invalid refresh token");
        }

        return user;
    }

    public String generateAccessToken(User user) {
        return jwtUtil.generateAccessToken(user);
    }

    public void saveRefreshToken(String phone, String refreshToken) {
        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setRefreshToken(refreshToken);
        userRepository.save(user);
    }

    public boolean PhoneResetPasswordHandle(String phone, Model model) {
        User user = userRepository.findByPhone(phone).orElse(null);
        if (user == null) {
            model.addAttribute("error", "Số điện thoại không tồn tại.");
            return false;
        }
        if (!user.getVerifyPhone()) {
            model.addAttribute("error", "Số điện thoại chưa được xác thực.");
            return false;
        }

        String newPassword = PasswordConfig.generateRandomPassword();
        String smsBody = "Mật khẩu mới sau khi reset của bạn là: " + newPassword;
        String formattedPhone = formatPhone(phone);
        boolean smsSentSuccessfully;

        try {
            smsSentSuccessfully = sSms.sendSMS(formattedPhone, smsBody);
        } catch (IOException e) {
            log.error("Lỗi gửi SMS reset mật khẩu cho phone={}", phone, e);
            model.addAttribute("error", "Lỗi hệ thống gửi SMS, vui lòng thử lại sau.");
            return false;
        }

        if (!smsSentSuccessfully) {
            model.addAttribute("error",
                    "Gửi SMS thất bại. Vui lòng kiểm tra lại SĐT hoặc liên hệ admin.");
            return false;
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        // [LOGGING] Ghi log reset mật khẩu qua SMS - OWASP A09
        SecurityEventLogger.passwordReset(phone, getClientIp(), "SMS");

        return true;
    }

    public boolean EmailResetPasswordHandle(String email, Model model) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null) {
            model.addAttribute("error", "Email không tồn tại.");
            return false;
        }
        if (!user.getVerifyEmail()) {
            model.addAttribute("error", "Email chưa được xác thực.");
            return false;
        }

        String newPassword = PasswordConfig.generateRandomPassword();
        // Gửi email chứa mật khẩu mới
        String emailBody = "Mật khẩu mới sau khi reset của bạn là: " + newPassword;
        emailService.sendEmail(email, "Reset Mật Khẩu", emailBody);
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        // [LOGGING] Ghi log reset mật khẩu qua Email - OWASP A09
        SecurityEventLogger.passwordReset(email, getClientIp(), "EMAIL");

        return true;
    }

    public String changePassword(ChangePassRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String phone = auth.getName();

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Tài khoản không tồn tại!"));

        if (!user.getIsActive()) {
            throw new RuntimeException("Tài khoản đã bị khóa.");
            // return "Tài khoản đã bị khóa.";
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new RuntimeException("Mật khẩu cũ không đúng!");
            // return "Mật khẩu cũ không đúng!";
        }

        // Validate mật khẩu mới
        if (!isValidPassword(request.getNewPassword())) {
            throw new RuntimeException(
                    "Mật khẩu mới phải có ít nhất 12 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (!@#$%...)!");
        }

        if (!request.getNewPassword().equals(request.getConfirmNewPassword())) {
            throw new RuntimeException("Mật khẩu mới và xác nhận mật khẩu không khớp!");
            // return "Mật khẩu mới và xác nhận mật khẩu không khớp!";
        }

        user.setPasswordHash(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);

        return "Đổi mật khẩu thành công!";
    }

    public String sendOtpEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String phone = auth.getName();

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("phone không tồn tại"));
        String email = user.getEmail();

        String otp = generateOtp();
        OtpCode otpEntity = OtpCode.builder()
                .user(user)
                .otpCode(otp)
                .expiryTime(LocalDateTime.now().plusMinutes(5))
                .type(OtpType.EMAIL)
                .used(false)
                .build();

        otpCodeRepository.save(otpEntity);

        // Gửi OTP qua Email
        String subject = "Your OTP Code";
        String body = "Your OTP code is: " + otp;
        emailService.sendEmail(email, subject, body);

        return "OTP đã được gửi đến email của bạn.";
    }

    public String sendOtpPhone() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String phone = auth.getName();

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Số điện thoại không tồn tại"));
        String formattedPhone = formatPhone(phone);
        // formattedPhone = "+18777804236";
        // Sinh OTP 6 số
        String otp = generateOtp();

        OtpCode otpEntity = OtpCode.builder()
                .user(user)
                .otpCode(otp)
                .expiryTime(LocalDateTime.now().plusMinutes(5))
                .used(false)
                .type(OtpType.PHONE)
                .build();

        otpCodeRepository.save(otpEntity);

        // Gửi OTP qua SMS
        sSms.sendOtp(formattedPhone, otp);

        return "OTP đã được gửi đến số điện thoại của bạn.";
    }

    // Verify OTP
    public String verifyOtp(String otpInput) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String phone = auth.getName();

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Số điện thoại không tồn tại"));

        Optional<OtpCode> otpEntityOpt = otpCodeRepository.findByUserAndOtpCodeAndUsedFalse(user, otpInput);

        if (otpEntityOpt.isEmpty()) {
            throw new RuntimeException("Mã OTP không đúng hoặc đã được sử dụng.");
            // return "Mã OTP không đúng hoặc đã được sử dụng.";
        }

        OtpCode otpEntity = otpEntityOpt.get();

        if (otpEntity.getExpiryTime().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Mã OTP đã hết hạn.");
            // return "Mã OTP đã hết hạn.";
        }
        if (otpEntity.getType() == OtpType.EMAIL) {
            user.setVerifyEmail(true);
        } else if (otpEntity.getType() == OtpType.PHONE) {
            user.setVerifyPhone(true);
        }
        // ÄÃ¡nh dáº¥u OTP Ä‘Ã£ dÃ¹ng
        otpEntity.setUsed(true);
        userRepository.save(user);
        // otpCodeRepository.save(otpEntity);
        ///
        otpCodeRepository.delete(otpEntity);
        ///

        return "Xác thực OTP thành công.";
    }

    public boolean isPhoneExist(String phone) {
        return userRepository.findByPhone(phone).isPresent();
    }

    private String formatPhone(String phone) {
        if (phone.startsWith("0")) {
            return "84" + phone.substring(1);
        } else if (phone.startsWith("84")) {
            return phone;
        } else {
            throw new IllegalArgumentException("Số điện thoại không đúng định dạng VN: " + phone);
        }
    }

    private String formatEmail(String email) {
        if (email.contains("@")) {
            return email;
        } else {
            throw new IllegalArgumentException("Email không đúng định dạng: " + email);
        }
    }

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private String generateOtp() {
        int otp = SECURE_RANDOM.nextInt(900000) + 100000;
        return String.valueOf(otp);
    }

    private boolean isValidPhone(String phone) {
        if (phone == null || phone.isEmpty()) {
            return false;
        }
        // Chỉ chấp nhận 10 chữ số
        return phone.matches("^[0-9]{10}$");
    }

    private boolean isValidEmail(String email) {
        if (email == null || email.isEmpty()) {
            return false;
        }
        // Regex cho email hợp lệ
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }

    // [FIX A04] 
    // - Tối thiểu 12 ký tự
    // - Tối đa 128 ký tự (ngăn DoS với password cực dài trước khi BCrypt xử lý)
    // - Bắt buộc 4 loại ký tự: hoa, thường, số, đặc biệt
    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 12)
            return false; // [FIX A04] tăng min từ 8 lên 12
        if (password.length() > 128)
            return false; // [FIX A04] giới hạn max để ngăn DoS
        if (!password.matches(".*[A-Z].*"))
            return false; // ít nhất 1 chữ hoa
        if (!password.matches(".*[a-z].*"))
            return false; // ít nhất 1 chữ thường
        if (!password.matches(".*[0-9].*"))
            return false; // ít nhất 1 chữ số
        if (!password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{}|;':,./<>?].*"))
            return false; // ký tự đặc biệt
        return true;
    }

}
