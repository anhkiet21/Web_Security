package com.proj.webprojrct.auth.service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import com.proj.webprojrct.sms.smsService;
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

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class AuthService {

    private final OtpCodeRepository otpCodeRepository;
    private final AuthMapper authMapper;
    private final AuthenticationManager authManager;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final smsService smsS;
    private final speedSMsService sSms;
    private final emailService emailService;
    private final JwtUtil jwtUtil;

    public LoginResponse handleLogin(String phone, String password, HttpSession session, Model model) throws Exception {

        try {
            Authentication auth = authManager.authenticate(
                    new UsernamePasswordAuthenticationToken(phone, password)
            );

            CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
            User user = userDetails.getUser();

            if (user == null || !user.getIsActive()) {
                throw new RuntimeException("TÃ i khoáº£n khÃ´ng tá»“n táº¡i hoáº·c Ä‘Ã£ bá»‹ khÃ³a.");
            }

            String accessToken = jwtUtil.generateAccessToken(user);
            String refreshToken = jwtUtil.generateRefreshToken(user);

            // LÆ°u refresh token vÃ o DB
            user.setRefreshToken(refreshToken);
            userRepository.save(user);

            return new LoginResponse(user, accessToken, refreshToken);
        } catch (org.springframework.security.authentication.DisabledException e) {
            model.addAttribute("error", "TÃ i khoáº£n Ä‘Ã£ bá»‹ vÃ´ hiá»‡u hÃ³a. Vui lÃ²ng liÃªn há»‡ quáº£n trá»‹ viÃªn.");
            throw new RuntimeException("TÃ i khoáº£n Ä‘Ã£ bá»‹ vÃ´ hiá»‡u hÃ³a. Vui lÃ²ng liÃªn há»‡ quáº£n trá»‹ viÃªn.");
        } catch (BadCredentialsException e) {
            model.addAttribute("error", "Sai sá»‘ Ä‘iá»‡n thoáº¡i hoáº·c máº­t kháº©u!");
            throw new RuntimeException("Sai sá»‘ Ä‘iá»‡n thoáº¡i hoáº·c máº­t kháº©u!");
        }
    }

    public void validateRegisterRequest(RegisterRequest request) {
        // Validate password
        if (!isValidPassword(request.getPassword())) {
            throw new RuntimeException("Máº­t kháº©u pháº£i cÃ³ Ã­t nháº¥t 6 kÃ½ tá»±, bao gá»“m cáº£ chá»¯ cÃ¡i vÃ  sá»‘!");
        }

        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new RuntimeException("Máº­t kháº©u vÃ  xÃ¡c nháº­n máº­t kháº©u khÃ´ng khá»›p!");
        }

        // Validate phone (10 digits)
        if (!isValidPhone(request.getPhone())) {
            throw new RuntimeException("Sá»‘ Ä‘iá»‡n thoáº¡i pháº£i cÃ³ Ä‘Ãºng 10 chá»¯ sá»‘!");
        }

        if (userRepository.existsByPhone(request.getPhone())) {
            throw new RuntimeException("Sá»‘ Ä‘iá»‡n thoáº¡i Ä‘Ã£ Ä‘Æ°á»£c Ä‘Äƒng kÃ½!");
        }

        // Validate email
        if (!isValidEmail(request.getEmail())) {
            throw new RuntimeException("Email khÃ´ng há»£p lá»‡!");
        }

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email Ä‘Ã£ Ä‘Æ°á»£c Ä‘Äƒng kÃ½!");
        }
    }

    /**
     * Táº¡o user sau khi OTP Ä‘Ã£ Ä‘Æ°á»£c xÃ¡c thá»±c
     */
    public User createUserFromRegistration(RegisterRequest request) {
        User user = authMapper.toEntity(request);
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setRole(UserRole.USER);
        user.setVerifyPhone(true); // ÄÃ£ xÃ¡c thá»±c OTP
        return userRepository.save(user);
    }

    public User registerUser(RegisterRequest request) {
        // Validate password
        if (!isValidPassword(request.getPassword())) {
            throw new RuntimeException("Máº­t kháº©u pháº£i cÃ³ Ã­t nháº¥t 6 kÃ½ tá»±, bao gá»“m cáº£ chá»¯ cÃ¡i vÃ  sá»‘!");
        }
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new RuntimeException("Máº­t kháº©u vÃ  xÃ¡c nháº­n máº­t kháº©u khÃ´ng khá»›p!");
        }
        // Validate phone (10 digits)
        if (!isValidPhone(request.getPhone())) {
            throw new RuntimeException("Sá»‘ Ä‘iá»‡n thoáº¡i pháº£i cÃ³ Ä‘Ãºng 10 chá»¯ sá»‘!");
        }
        if (userRepository.existsByPhone(request.getPhone())) {
            throw new RuntimeException("Sá»‘ Ä‘iá»‡n thoáº¡i Ä‘Ã£ Ä‘Æ°á»£c Ä‘Äƒng kÃ½!");
        }
        // Validate email
        if (!isValidEmail(request.getEmail())) {
            throw new RuntimeException("Email khÃ´ng há»£p lá»‡!");
        }
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email Ä‘Ã£ Ä‘Æ°á»£c Ä‘Äƒng kÃ½!");
        }
        User user = authMapper.toEntity(request);
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setRole(UserRole.USER);
        return userRepository.save(user);
    }

    public User handleRefreshToken(String refreshToken) {
        // Láº¥y username tá»« refresh token
        String username = jwtUtil.extractUsername(refreshToken);

        User user = userRepository.findByPhone(username)
                .orElseThrow(() -> new RuntimeException("User khÃ´ng tá»“n táº¡i"));

        // So sÃ¡nh vá»›i refresh token trong DB
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
            model.addAttribute("error", "Sá»‘ Ä‘iá»‡n thoáº¡i khÃ´ng tá»“n táº¡i.");
            return false;
        }
        if (!user.getVerifyPhone()) {
            model.addAttribute("error", "Sá»‘ Ä‘iá»‡n thoáº¡i chÆ°a Ä‘Æ°á»£c xÃ¡c thá»±c.");
            return false;
        }

        String newPassword = PasswordConfig.generateRandomPassword();
        String smsBody = "Máº­t kháº©u má»›i sau khi reset cá»§a báº¡n lÃ : " + newPassword;
        String formattedPhone = formatPhone(phone);
        boolean smsSentSuccessfully;

        try {
            smsSentSuccessfully = sSms.sendSMS(formattedPhone, smsBody);
        } catch (IOException e) {
            e.printStackTrace();
            model.addAttribute("error", "Lá»—i há»‡ thá»‘ng gá»­i SMS, vui lÃ²ng thá»­ láº¡i sau.");
            return false;
        }

        if (!smsSentSuccessfully) {
            model.addAttribute("error", "Gá»­i SMS tháº¥t báº¡i. Vui lÃ²ng kiá»ƒm tra láº¡i SÄT hoáº·c liÃªn há»‡ admin.");
            return false;
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        return true;
    }

    public boolean EmailResetPasswordHandle(String email, Model model) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null) {
            model.addAttribute("error", "Email khÃ´ng tá»“n táº¡i.");
            return false;
        }
        if (!user.getVerifyEmail()) {
            model.addAttribute("error", "Email chÆ°a Ä‘Æ°á»£c xÃ¡c thá»±c.");
            return false;
        }

        String newPassword = PasswordConfig.generateRandomPassword();
        // Gá»­i email chá»©a máº­t kháº©u má»›i
        String emailBody = "Máº­t kháº©u má»›i sau khi reset cá»§a báº¡n lÃ : " + newPassword;
        emailService.sendEmail(email, "Reset Máº­t Kháº©u", emailBody);
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        return true;
    }

    public String changePassword(ChangePassRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String phone = auth.getName();

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("TÃ i khoáº£n khÃ´ng tá»“n táº¡i!"));

        if (!user.getIsActive()) {
            throw new RuntimeException("TÃ i khoáº£n Ä‘Ã£ bá»‹ khÃ³a.");
            //return "TÃ i khoáº£n Ä‘Ã£ bá»‹ khÃ³a.";
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new RuntimeException("Máº­t kháº©u cÅ© khÃ´ng Ä‘Ãºng!");
            //return "Máº­t kháº©u cÅ© khÃ´ng Ä‘Ãºng!";
        }

        // Validate máº­t kháº©u má»›i (tá»‘i thiá»ƒu 6 kÃ½ tá»±, cÃ³ chá»¯ vÃ  sá»‘)
        if (!isValidPassword(request.getNewPassword())) {
            throw new RuntimeException("Máº­t kháº©u má»›i pháº£i cÃ³ Ã­t nháº¥t 6 kÃ½ tá»±, bao gá»“m cáº£ chá»¯ cÃ¡i vÃ  sá»‘!");
        }

        if (!request.getNewPassword().equals(request.getConfirmNewPassword())) {
            throw new RuntimeException("Máº­t kháº©u má»›i vÃ  xÃ¡c nháº­n máº­t kháº©u khÃ´ng khá»›p!");
            //return "Máº­t kháº©u má»›i vÃ  xÃ¡c nháº­n máº­t kháº©u khÃ´ng khá»›p!";
        }

        user.setPasswordHash(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);

        return "Äá»•i máº­t kháº©u thÃ nh cÃ´ng!";
    }

    public String sendOtpEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String phone = auth.getName();

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("phone khÃ´ng tá»“n táº¡i"));
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

        // Gá»­i OTP qua Email
        String subject = "Your OTP Code";
        String body = "Your OTP code is: " + otp;
        emailService.sendEmail(email, subject, body);

        return "OTP Ä‘Ã£ Ä‘Æ°á»£c gá»­i Ä‘áº¿n email cá»§a báº¡n.";
    }

    public String sendOtpPhone() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String phone = auth.getName();

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Sá»‘ Ä‘iá»‡n thoáº¡i khÃ´ng tá»“n táº¡i"));
        String formattedPhone = formatPhone(phone);
        //formattedPhone = "+18777804236";
        // Sinh OTP 6 sá»‘
        String otp = generateOtp();

        OtpCode otpEntity = OtpCode.builder()
                .user(user)
                .otpCode(otp)
                .expiryTime(LocalDateTime.now().plusMinutes(5))
                .used(false)
                .type(OtpType.PHONE)
                .build();

        otpCodeRepository.save(otpEntity);

        // Gá»­i OTP qua SMS
        sSms.sendOtp(formattedPhone, otp);

        return "OTP Ä‘Ã£ Ä‘Æ°á»£c gá»­i Ä‘áº¿n sá»‘ Ä‘iá»‡n thoáº¡i cá»§a báº¡n.";
    }

    // Verify OTP
    public String verifyOtp(String otpInput) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String phone = auth.getName();

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Sá»‘ Ä‘iá»‡n thoáº¡i khÃ´ng tá»“n táº¡i"));

        Optional<OtpCode> otpEntityOpt = otpCodeRepository.findByUserAndOtpCodeAndUsedFalse(user, otpInput);

        if (otpEntityOpt.isEmpty()) {
            throw new RuntimeException("MÃ£ OTP khÃ´ng Ä‘Ãºng hoáº·c Ä‘Ã£ Ä‘Æ°á»£c sá»­ dá»¥ng.");
            //return "MÃ£ OTP khÃ´ng Ä‘Ãºng hoáº·c Ä‘Ã£ Ä‘Æ°á»£c sá»­ dá»¥ng.";
        }

        OtpCode otpEntity = otpEntityOpt.get();

        if (otpEntity.getExpiryTime().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("MÃ£ OTP Ä‘Ã£ háº¿t háº¡n.");
            //return "MÃ£ OTP Ä‘Ã£ háº¿t háº¡n.";
        }
        if (otpEntity.getType() == OtpType.EMAIL) {
            user.setVerifyEmail(true);
        } else if (otpEntity.getType() == OtpType.PHONE) {
            user.setVerifyPhone(true);
        }
        // ÄÃ¡nh dáº¥u OTP Ä‘Ã£ dÃ¹ng
        otpEntity.setUsed(true);
        userRepository.save(user);
        //otpCodeRepository.save(otpEntity);
        ///    
        otpCodeRepository.delete(otpEntity);
        ///

        return "XÃ¡c thá»±c OTP thÃ nh cÃ´ng.";
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
            throw new IllegalArgumentException("Sá»‘ Ä‘iá»‡n thoáº¡i khÃ´ng Ä‘Ãºng Ä‘á»‹nh dáº¡ng VN: " + phone);
        }
    }

    private String formatEmail(String email) {
        if (email.contains("@")) {
            return email;
        } else {
            throw new IllegalArgumentException("Email khÃ´ng Ä‘Ãºng Ä‘á»‹nh dáº¡ng: " + email);
        }
    }

    private String generateOtp() {
        int otp = (int) (Math.random() * 900000) + 100000;
        return String.valueOf(otp);
    }

    private boolean isValidPhone(String phone) {
        if (phone == null || phone.isEmpty()) {
            return false;
        }
        // Chá»‰ cháº¥p nháº­n 10 chá»¯ sá»‘
        return phone.matches("^[0-9]{10}$");
    }

    private boolean isValidEmail(String email) {
        if (email == null || email.isEmpty()) {
            return false;
        }
        // Regex cho email há»£p lá»‡
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }

    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }
        // Pháº£i cÃ³ Ã­t nháº¥t 1 chá»¯ cÃ¡i vÃ  1 sá»‘
        boolean hasLetter = password.matches(".*[A-Za-z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        return hasLetter && hasDigit;
    }

}
