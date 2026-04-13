package com.proj.webprojrct.auth.controller;

import com.proj.webprojrct.auth.service.LoginAttemptService;
import com.proj.webprojrct.auth.service.AuthService;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.common.config.security.JwtUtil;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.proj.webprojrct.common.config.logging.SecurityEventLogger;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.common.config.security.SecureCookieUtil;

import java.util.HashMap;
import java.util.Map;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.proj.webprojrct.auth.dto.request.ChangePassRequest;
import com.proj.webprojrct.auth.dto.request.LoginRequest;
import com.proj.webprojrct.auth.dto.response.LoginResponse;

import lombok.*;
import com.proj.webprojrct.auth.dto.request.ChangePassRequest;
import com.proj.webprojrct.auth.dto.request.RegisterRequest;
import com.proj.webprojrct.auth.dto.request.LoginRequest;
import com.proj.webprojrct.auth.dto.request.RegisterRequest;
import com.proj.webprojrct.auth.dto.response.LoginResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@AllArgsConstructor
@Controller
public class AuthController {

    private static final Logger log = LoggerFactory.getLogger(AuthController.class);

    private final AuthenticationManager authManager;
    private final JwtUtil jwtUtil;
    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;
    private final AuthService authService;
    private final LoginAttemptService loginAttemptService; // FIX V-09

    @GetMapping("/login")
    public String loginPage() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            return "redirect:/home";
        }

        return "auth/login";
    }

    @PostMapping("/dologin")
    public String login(@ModelAttribute LoginRequest loginRequest,
            HttpServletResponse response,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) { // login
        String phone = loginRequest.getPhone();

        // FIX V-09: Kiểm tra khóa brute force
        if (loginAttemptService.isBlocked(phone)) {
            long minutes = loginAttemptService.getRemainingLockMinutes(phone);
            redirectAttributes.addFlashAttribute("error",
                    "Tài khoản bị khóa do quá nhiều lần đăng nhập sai. Thử lại sau " + minutes + " phút.");
            return "redirect:/login";
        }

        try {
            LoginResponse loginResponse = authService.handleLogin(
                    phone,
                    loginRequest.getPassword(),
                    session,
                    model);

            // FIX V-09: Đăng nhập thành công → xóa bộ đếm
            loginAttemptService.loginSucceeded(phone);

            User user = loginResponse.getUser();
            String accessToken = loginResponse.getAccessToken();
            String refreshToken = loginResponse.getRefreshToken();

            // [FIX V-04] Cookie bảo mật: Secure + SameSite=Lax
            SecureCookieUtil.addAccessTokenCookie(response, accessToken);
            SecureCookieUtil.addRefreshTokenCookie(response, refreshToken);

            return "redirect:/home";

        } catch (Exception e) {
            // FIX V-09: Đăng nhập thất bại → tăng bộ đếm
            loginAttemptService.loginFailed(phone);
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/login";
        }
    }

    @GetMapping("/home")
    public String homePage(Model model) {
        // Redirect to main home controller to ensure consistent data loading
        return "redirect:/";
    }

    @GetMapping("/refresh")
    public String refresh(@CookieValue("refresh_token") String refreshToken,
            HttpServletResponse response,
            Model model) {
        try {
            User user = authService.handleRefreshToken(refreshToken);
            String newAccess = authService.generateAccessToken(user);

            // [FIX V-04] Cookie bảo mật: Secure + SameSite=Lax
            SecureCookieUtil.addAccessTokenCookie(response, newAccess);

            model.addAttribute("message", "Token refreshed successfully!");
            model.addAttribute("user", user.getFullName());
            model.addAttribute("role", user.getRole().name());
            model.addAttribute("phone", user.getPhone());

            return "home";
        } catch (Exception e) {
            log.error("Lỗi khi refresh token", e);
            model.addAttribute("error", "Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.");
            return "auth/login";
        }
    }

    @PostMapping("/dologout")
    public String logout(@CookieValue(value = "refresh_token", required = false) String refreshToken,
            HttpServletResponse response,
            HttpSession session,
            HttpServletRequest request) {
        // [LOGGING] Lấy username trước khi xóa SecurityContext - OWASP A09
        String loggedUsername = "anonymous";
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            loggedUsername = ((CustomUserDetails) authentication.getPrincipal()).getUsername();
        }
        if (authentication != null && authentication.isAuthenticated()) {
            SecurityContextHolder.clearContext();
        }
        // XÃ³a token trong DB
        if (refreshToken != null) {
            try {
                String phone = jwtUtil.extractUsername(refreshToken);
                User user = userRepo.findByPhone(phone).orElse(null);
                if (user != null) {
                    user.setRefreshToken(null);
                    userRepo.save(user);
                    if ("anonymous".equals(loggedUsername))
                        loggedUsername = phone;
                }
            } catch (Exception e) {
                // token khÃ´ng há»£p lá»‡ thÃ¬ bá» qua
            }
        }
        // [LOGGING] Ghi log đăng xuất - OWASP A09
        SecurityEventLogger.logout(loggedUsername, getClientIp(request));

        // [FIX V-04] Xóa cookie bảo mật: Secure + SameSite=Lax
        SecureCookieUtil.clearAccessTokenCookie(response);
        SecureCookieUtil.clearRefreshTokenCookie(response);

        session.invalidate();

        return "redirect:/login";
    }

    @GetMapping("/register")
    public String registerPage() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            return "redirect:/home";
        }
        return "auth/register";
    }

    @PostMapping("/doregister")
    public String register(@ModelAttribute RegisterRequest request, Model model, RedirectAttributes redirectAttributes,
            HttpSession session, HttpServletResponse response) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            return "redirect:/home";
        }

        try {
            // Táº¡o user nhÆ°ng chÆ°a xÃ¡c thá»±c phone
            User newUser = authService.registerUser(request);

            // Tá»± Ä‘á»™ng Ä‘Äƒng nháº­p user báº±ng cÃ¡ch táº¡o token
            UserDetails userDetails = new CustomUserDetails(newUser);
            String accessToken = authService.generateAccessToken(newUser);
            String refreshToken = jwtUtil.generateRefreshToken(userDetails);

            // LÆ°u refresh token vÃ o database
            authService.saveRefreshToken(newUser.getPhone(), refreshToken);

            // [FIX V-04] Cookie bảo mật: Secure + SameSite=Lax
            SecureCookieUtil.addAccessTokenCookie(response, accessToken);
            SecureCookieUtil.addRefreshTokenCookie(response, refreshToken);

            // Authenticate user trong SecurityContext
            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userDetails,
                    null, userDetails.getAuthorities());
            SecurityContextHolder.getContext().setAuthentication(authentication);

            // Lưu userId vào session để trang verify biết
            session.setAttribute("newUserId", newUser.getId());

            // Chuyển đến trang xác thực phone với tùy chọn "Để sau"
            redirectAttributes.addFlashAttribute("message",
                    "Đăng ký thành công! Vui lòng xác thực số điện thoại.");
            redirectAttributes.addFlashAttribute("phone", request.getPhone());
            return "redirect:/register-phone-verify";
        } catch (RuntimeException e) {
            // preserve entered values except passwords
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            redirectAttributes.addFlashAttribute("fullName", request.getFullName());
            redirectAttributes.addFlashAttribute("phone", request.getPhone());
            redirectAttributes.addFlashAttribute("email", request.getEmail());
            return "redirect:/register";
        }
    }

    @GetMapping("/resetPassword")
    public String resetPasswordPage() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            return "redirect:/home"; // Đã đăng nhập, chuyển hướng
        }
        return "auth/resetPassword";
    }

    @PostMapping("/doResetPassword")
    // public String resetPassword(@RequestParam String input, Model model) {
    public String resetPassword(@RequestParam String input, Model model, RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            return "redirect:/home"; // người dùng đã đăng nhập
        }

        if (input == null || input.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Vui lòng nhập email hoặc số điện thoại.");
            // return "resetPassword";
            redirectAttributes.addFlashAttribute("input", input);
            return "redirect:/resetPassword";
        }

        if (input.contains("@")) {
            boolean result = authService.EmailResetPasswordHandle(input, model);
            if (!result) {
                // return "resetPassword";

                // giáº£i quyáº¿t email cÃ i model.error
                if (model.containsAttribute("error")) {
                    redirectAttributes.addFlashAttribute("error", model.asMap().get("error"));
                }
                redirectAttributes.addFlashAttribute("input", input);
                return "redirect:/resetPassword";
            }
            redirectAttributes.addFlashAttribute("message",
                    "Mật khẩu mới đã được gửi qua email. Vui lòng kiểm tra email của bạn.");
        } else {
            boolean result = authService.PhoneResetPasswordHandle(input, model);
            if (!result) {
                if (model.containsAttribute("error")) {
                    redirectAttributes.addFlashAttribute("error", model.asMap().get("error"));
                }
                redirectAttributes.addFlashAttribute("input", input);
                return "redirect:/resetPassword";
            }
            redirectAttributes.addFlashAttribute("message",
                    "Mật khẩu mới đã được gửi qua SMS. Vui lòng kiểm tra điện thoại của bạn.");
        }

        return "redirect:/resetPassword";
        // return "resetPassword";
    }

    @PostMapping("/change-password")
    public String changePassword(@ModelAttribute ChangePassRequest request, RedirectAttributes redirectAttributes) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            redirectAttributes.addFlashAttribute("passwordChangeMessage",
                    "Bạn cần đăng nhập để đổi mật khẩu.");
            redirectAttributes.addFlashAttribute("passwordChangeSuccess", false);
            return "redirect:/login";
        }

        String message;
        boolean success = true;
        try {
            message = authService.changePassword(request);
        } catch (RuntimeException ex) {
            message = ex.getMessage();
            success = false;
        }

        redirectAttributes.addFlashAttribute("passwordChangeMessage", message);
        redirectAttributes.addFlashAttribute("passwordChangeSuccess", success);
        return "redirect:/profile";
    }

    @GetMapping("/change-password")
    public String showChangePasswordForm(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        model.addAttribute("changePassRequest", new ChangePassRequest());
        return "auth/change-password";
    }

    // ========== REGISTER PHONE VERIFICATION ==========
    @GetMapping("/register-phone-verify")
    public String showRegisterPhoneVerify(HttpSession session, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        Long userId = (Long) session.getAttribute("newUserId");
        if (userId == null) {
            model.addAttribute("error", "Phiên đăng ký đã hết hạn. Vui lòng đăng ký lại.");
            return "redirect:/register";
        }

        // Lấy thông tin user để hiển thị phone
        User user = userRepo.findById(userId).orElse(null);
        if (user == null) {
            model.addAttribute("error", "Không tìm thấy thông tin tài khoản.");
            return "redirect:/register";
        }

        model.addAttribute("phone", user.getPhone());
        model.addAttribute("userId", userId);
        return "auth/register-phone-verify";
    }

    @PostMapping("/register-phone-skip")
    public String skipPhoneVerification(HttpSession session, RedirectAttributes redirectAttributes) {
        // Xóa session và chuyển về login
        session.removeAttribute("newUserId");
        redirectAttributes.addFlashAttribute("message",
                "Bạn có thể xác thực số điện thoại sau trong phần cài đặt tài khoản.");
        return "redirect:/login";
    }

    // ========== END REGISTER PHONE VERIFICATION ==========
    // @GetMapping("/verify-otp")
    // public String showOtpForm(Model model) {
    // Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    // if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof
    // CustomUserDetails) {
    // return "verify-otp";
    // }
    // return "redirect:/home";
    // }
    // @PostMapping("/send-otp-email")
    // public String sendOtpEmail(Model model) {
    // Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    // if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal()
    // instanceof CustomUserDetails)) {
    // return "redirect:/home";
    // }
    // try {
    // String msg = authService.sendOtpEmail();
    // model.addAttribute("success", msg);
    // } catch (Exception e) {
    // model.addAttribute("error", e.getMessage());
    // }
    // return "auth/verify-otp";
    // }
    // // Gá»­i OTP phone
    // @PostMapping("/send-otp-phone")
    // public String sendOtpPhone(Model model) {
    // Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    // if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal()
    // instanceof CustomUserDetails)) {
    // return "redirect:/home";
    // }
    // try {
    // String msg = authService.sendOtpPhone();
    // model.addAttribute("success", msg);
    // } catch (Exception e) {
    // model.addAttribute("error", e.getMessage());
    // }
    // return "auth/verify-otp";
    // }
    // // XÃ¡c thá»±c OTP
    // @PostMapping("/verify-otp")
    // public String verifyOtp(@RequestParam("otp") String otpInput, Model model) {
    // Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    // if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal()
    // instanceof CustomUserDetails)) {
    // return "redirect:/home";
    // }
    // try {
    // String msg = authService.verifyOtp(otpInput);
    // model.addAttribute("success", msg);
    // } catch (Exception e) {
    // model.addAttribute("error", e.getMessage());
    // }
    // return "auth/verify-otp";
    // }
    // API endpoints for AJAX calls
    @PostMapping("/api/send-otp")
    @ResponseBody
    public Map<String, Object> sendOtpAPI(@RequestParam("type") String type) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()
                || !(authentication.getPrincipal() instanceof CustomUserDetails)) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Người dùng chưa đăng nhập");
            return errorResponse;
        }
        Map<String, Object> response = new HashMap<>();

        try {
            String msg;
            if ("email".equals(type)) {
                msg = authService.sendOtpEmail();
            } else if ("phone".equals(type)) {
                msg = authService.sendOtpPhone();
            } else {
                response.put("success", false);
                response.put("message", "Loại xác thực không hợp lệ");
                return response;
            }
            response.put("success", true);
            response.put("message", msg);
        } catch (Exception e) {
            log.error("Lỗi khi gửi OTP type={}", type, e);
            response.put("success", false);
            response.put("message", "Lỗi hệ thống khi gửi mã xác thực. Vui lòng thử lại.");
        }
        return response;
    }

    @PostMapping("/api/verify-otp")
    @ResponseBody
    public Map<String, Object> verifyOtpAPI(@RequestParam("otp") String otpInput) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()
                || !(authentication.getPrincipal() instanceof CustomUserDetails)) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Người dùng chưa đăng nhập");
            return errorResponse;
        }
        Map<String, Object> response = new HashMap<>();

        try {
            String msg = authService.verifyOtp(otpInput);
            response.put("success", true);
            response.put("message", msg);
        } catch (Exception e) {
            log.error("Lỗi khi xác thực OTP", e);
            response.put("success", false);
            response.put("message", "Lỗi hệ thống khi xác thực. Vui lòng thử lại.");
        }
        return response;
    }

    // [LOGGING] Lấy IP thực của client - OWASP A09
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
