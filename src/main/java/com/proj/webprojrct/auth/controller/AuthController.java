package com.proj.webprojrct.auth.controller;

import com.proj.webprojrct.auth.service.AuthService;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.common.config.security.JwtUtil;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.proj.webprojrct.common.config.security.CustomUserDetails;

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

@AllArgsConstructor
@Controller
public class AuthController {

    private final AuthenticationManager authManager;
    private final JwtUtil jwtUtil;
    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;
    private final AuthService authService;

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
            RedirectAttributes redirectAttributes) { //login
        try {
            LoginResponse loginResponse = authService.handleLogin(
                    loginRequest.getPhone(),
                    loginRequest.getPassword(),
                    session,
                    model
            );

            User user = loginResponse.getUser();
            String accessToken = loginResponse.getAccessToken();
            String refreshToken = loginResponse.getRefreshToken();

            Cookie accessCookie = new Cookie("access_token", accessToken);
            accessCookie.setHttpOnly(true);
            accessCookie.setPath("/");
            response.addCookie(accessCookie);

            Cookie refreshCookie = new Cookie("refresh_token", refreshToken);
            refreshCookie.setHttpOnly(true);
            refreshCookie.setPath("/");
            response.addCookie(refreshCookie);

            return "redirect:/home";

        } catch (Exception e) {
            //model.addAttribute("error", e.getMessage());
            //return "login";
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/login"; //giữ lại model login
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

            Cookie accessCookie = new Cookie("access_token", newAccess);
            accessCookie.setHttpOnly(true);
            accessCookie.setPath("/");
            response.addCookie(accessCookie);

            model.addAttribute("message", "Token refreshed successfully!");
            model.addAttribute("user", user.getFullName());
            model.addAttribute("role", user.getRole().name());
            model.addAttribute("phone", user.getPhone());

            return "home";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "auth/login";
        }
    }

    @PostMapping("/dologout")
    public String logout(@CookieValue(value = "refresh_token", required = false) String refreshToken,
            HttpServletResponse response,
            HttpSession session) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            SecurityContextHolder.clearContext();
        }
        // Xóa token trong DB
        if (refreshToken != null) {
            try {
                String phone = jwtUtil.extractUsername(refreshToken);
                User user = userRepo.findByPhone(phone).orElse(null);
                if (user != null) {
                    user.setRefreshToken(null);
                    userRepo.save(user);
                }
            } catch (Exception e) {
                // token không hợp lệ thì bỏ qua
            }
        }

        Cookie accessCookie = new Cookie("access_token", null);
        accessCookie.setHttpOnly(true);
        accessCookie.setPath("/");          // path giống lúc tạo
        accessCookie.setDomain("localhost"); // domain giống lúc tạo
        accessCookie.setMaxAge(0);          // xóa cookie
        response.addCookie(accessCookie);

        // Xóa refresh_token
        Cookie refreshCookie = new Cookie("refresh_token", null);
        refreshCookie.setHttpOnly(true);
        refreshCookie.setPath("/");
        refreshCookie.setDomain("localhost");
        refreshCookie.setMaxAge(0);
        response.addCookie(refreshCookie);

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
            // Tạo user nhưng chưa xác thực phone
            User newUser = authService.registerUser(request);

            // Tự động đăng nhập user bằng cách tạo token
            UserDetails userDetails = new CustomUserDetails(newUser);
            String accessToken = authService.generateAccessToken(newUser);
            String refreshToken = jwtUtil.generateRefreshToken(userDetails);

            // Lưu refresh token vào database
            authService.saveRefreshToken(newUser.getPhone(), refreshToken);

            // Lưu token vào cookie
            Cookie accessCookie = new Cookie("access_token", accessToken);
            accessCookie.setHttpOnly(true);
            accessCookie.setPath("/");
            response.addCookie(accessCookie);

            Cookie refreshCookie = new Cookie("refresh_token", refreshToken);
            refreshCookie.setHttpOnly(true);
            refreshCookie.setPath("/");
            response.addCookie(refreshCookie);

            // Authenticate user trong SecurityContext
            UsernamePasswordAuthenticationToken authentication
                    = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
            SecurityContextHolder.getContext().setAuthentication(authentication);

            // Lưu userId vào session để trang verify biết
            session.setAttribute("newUserId", newUser.getId());

            // Chuyển đến trang xác thực phone với tùy chọn "Để sau"
            redirectAttributes.addFlashAttribute("message", "Đăng ký thành công! Vui lòng xác thực số điện thoại.");
            redirectAttributes.addFlashAttribute("phone", request.getPhone());
            System.out.println("Debug: Stored newUserId in session = " + newUser.getId());
            System.out.println("Debug: User auto-logged in with token");
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
            //return "resetPassword";
            redirectAttributes.addFlashAttribute("input", input);
            return "redirect:/resetPassword";
        }

        if (input.contains("@")) {
            boolean result = authService.EmailResetPasswordHandle(input, model);
            if (!result) {
                //return "resetPassword";

                // giải quyết email cài model.error
                if (model.containsAttribute("error")) {
                    redirectAttributes.addFlashAttribute("error", model.asMap().get("error"));
                }
                redirectAttributes.addFlashAttribute("input", input);
                return "redirect:/resetPassword";
            }
            redirectAttributes.addFlashAttribute("message", "Mật khẩu mới đã được gửi qua email. Vui lòng kiểm tra email của bạn.");
        } else {
            boolean result = authService.PhoneResetPasswordHandle(input, model);
            if (!result) {
                if (model.containsAttribute("error")) {
                    redirectAttributes.addFlashAttribute("error", model.asMap().get("error"));
                }
                redirectAttributes.addFlashAttribute("input", input);
                return "redirect:/resetPassword";
            }
            redirectAttributes.addFlashAttribute("message", "Mật khẩu mới đã được gửi qua SMS. Vui lòng kiểm tra điện thoại của bạn.");
        }

        return "redirect:/resetPassword";
        //return "resetPassword";
    }

    @PostMapping("/change-password")
    public String changePassword(@ModelAttribute ChangePassRequest request, RedirectAttributes redirectAttributes) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            redirectAttributes.addFlashAttribute("passwordChangeMessage", "Bạn cần đăng nhập để đổi mật khẩu.");
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
        System.out.println("Debug: newUserId in session = " + userId);
        if (userId == null) {
            model.addAttribute("error", "Phiên đã hết hạn. Vui lòng đăng ký lại.");
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
        redirectAttributes.addFlashAttribute("message", "Bạn có thể xác thực số điện thoại sau trong phần cài đặt tài khoản.");
        return "redirect:/login";
    }

    // ========== END REGISTER PHONE VERIFICATION ==========
    // @GetMapping("/verify-otp")
    // public String showOtpForm(Model model) {
    //     Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    //     if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
    //         return "verify-otp";
    //     }
    //     return "redirect:/home";
    // }
    // @PostMapping("/send-otp-email")
    // public String sendOtpEmail(Model model) {
    //     Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    //     if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal() instanceof CustomUserDetails)) {
    //         return "redirect:/home";
    //     }
    //     try {
    //         String msg = authService.sendOtpEmail();
    //         model.addAttribute("success", msg);
    //     } catch (Exception e) {
    //         model.addAttribute("error", e.getMessage());
    //     }
    //     return "auth/verify-otp";
    // }
    // // Gửi OTP phone
    // @PostMapping("/send-otp-phone")
    // public String sendOtpPhone(Model model) {
    //     Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    //     if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal() instanceof CustomUserDetails)) {
    //         return "redirect:/home";
    //     }
    //     try {
    //         String msg = authService.sendOtpPhone();
    //         model.addAttribute("success", msg);
    //     } catch (Exception e) {
    //         model.addAttribute("error", e.getMessage());
    //     }
    //     return "auth/verify-otp";
    // }
    // // Xác thực OTP
    // @PostMapping("/verify-otp")
    // public String verifyOtp(@RequestParam("otp") String otpInput, Model model) {
    //     Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    //     if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal() instanceof CustomUserDetails)) {
    //         return "redirect:/home";
    //     }
    //     try {
    //         String msg = authService.verifyOtp(otpInput);
    //         model.addAttribute("success", msg);
    //     } catch (Exception e) {
    //         model.addAttribute("error", e.getMessage());
    //     }
    //     return "auth/verify-otp";
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
            response.put("success", false);
            response.put("message", e.getMessage());
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
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

}
