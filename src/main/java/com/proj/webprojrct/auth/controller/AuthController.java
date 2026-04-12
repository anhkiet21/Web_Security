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
            return "redirect:/login"; //giá»¯ láº¡i model login
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
        // XÃ³a token trong DB
        if (refreshToken != null) {
            try {
                String phone = jwtUtil.extractUsername(refreshToken);
                User user = userRepo.findByPhone(phone).orElse(null);
                if (user != null) {
                    user.setRefreshToken(null);
                    userRepo.save(user);
                }
            } catch (Exception e) {
                // token khÃ´ng há»£p lá»‡ thÃ¬ bá» qua
            }
        }

        Cookie accessCookie = new Cookie("access_token", null);
        accessCookie.setHttpOnly(true);
        accessCookie.setPath("/");          // path giá»‘ng lÃºc táº¡o
        accessCookie.setDomain("localhost"); // domain giá»‘ng lÃºc táº¡o
        accessCookie.setMaxAge(0);          // xÃ³a cookie
        response.addCookie(accessCookie);

        // XÃ³a refresh_token
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
            // Táº¡o user nhÆ°ng chÆ°a xÃ¡c thá»±c phone
            User newUser = authService.registerUser(request);

            // Tá»± Ä‘á»™ng Ä‘Äƒng nháº­p user báº±ng cÃ¡ch táº¡o token
            UserDetails userDetails = new CustomUserDetails(newUser);
            String accessToken = authService.generateAccessToken(newUser);
            String refreshToken = jwtUtil.generateRefreshToken(userDetails);

            // LÆ°u refresh token vÃ o database
            authService.saveRefreshToken(newUser.getPhone(), refreshToken);

            // LÆ°u token vÃ o cookie
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

            // LÆ°u userId vÃ o session Ä‘á»ƒ trang verify biáº¿t
            session.setAttribute("newUserId", newUser.getId());

            // Chuyá»ƒn Ä‘áº¿n trang xÃ¡c thá»±c phone vá»›i tÃ¹y chá»n "Äá»ƒ sau"
            redirectAttributes.addFlashAttribute("message", "ÄÄƒng kÃ½ thÃ nh cÃ´ng! Vui lÃ²ng xÃ¡c thá»±c sá»‘ Ä‘iá»‡n thoáº¡i.");
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
            return "redirect:/home"; // ÄÃ£ Ä‘Äƒng nháº­p, chuyá»ƒn hÆ°á»›ng
        }
        return "auth/resetPassword";
    }

    @PostMapping("/doResetPassword")
    // public String resetPassword(@RequestParam String input, Model model) {
    public String resetPassword(@RequestParam String input, Model model, RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            return "redirect:/home"; // ngÆ°á»i dÃ¹ng Ä‘Ã£ Ä‘Äƒng nháº­p
        }

        if (input == null || input.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Vui lÃ²ng nháº­p email hoáº·c sá»‘ Ä‘iá»‡n thoáº¡i.");
            //return "resetPassword";
            redirectAttributes.addFlashAttribute("input", input);
            return "redirect:/resetPassword";
        }

        if (input.contains("@")) {
            boolean result = authService.EmailResetPasswordHandle(input, model);
            if (!result) {
                //return "resetPassword";

                // giáº£i quyáº¿t email cÃ i model.error
                if (model.containsAttribute("error")) {
                    redirectAttributes.addFlashAttribute("error", model.asMap().get("error"));
                }
                redirectAttributes.addFlashAttribute("input", input);
                return "redirect:/resetPassword";
            }
            redirectAttributes.addFlashAttribute("message", "Máº­t kháº©u má»›i Ä‘Ã£ Ä‘Æ°á»£c gá»­i qua email. Vui lÃ²ng kiá»ƒm tra email cá»§a báº¡n.");
        } else {
            boolean result = authService.PhoneResetPasswordHandle(input, model);
            if (!result) {
                if (model.containsAttribute("error")) {
                    redirectAttributes.addFlashAttribute("error", model.asMap().get("error"));
                }
                redirectAttributes.addFlashAttribute("input", input);
                return "redirect:/resetPassword";
            }
            redirectAttributes.addFlashAttribute("message", "Máº­t kháº©u má»›i Ä‘Ã£ Ä‘Æ°á»£c gá»­i qua SMS. Vui lÃ²ng kiá»ƒm tra Ä‘iá»‡n thoáº¡i cá»§a báº¡n.");
        }

        return "redirect:/resetPassword";
        //return "resetPassword";
    }

    @PostMapping("/change-password")
    public String changePassword(@ModelAttribute ChangePassRequest request, RedirectAttributes redirectAttributes) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            redirectAttributes.addFlashAttribute("passwordChangeMessage", "Báº¡n cáº§n Ä‘Äƒng nháº­p Ä‘á»ƒ Ä‘á»•i máº­t kháº©u.");
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
            model.addAttribute("error", "PhiÃªn Ä‘Ã£ háº¿t háº¡n. Vui lÃ²ng Ä‘Äƒng kÃ½ láº¡i.");
            return "redirect:/register";
        }

        // Láº¥y thÃ´ng tin user Ä‘á»ƒ hiá»ƒn thá»‹ phone
        User user = userRepo.findById(userId).orElse(null);
        if (user == null) {
            model.addAttribute("error", "KhÃ´ng tÃ¬m tháº¥y thÃ´ng tin tÃ i khoáº£n.");
            return "redirect:/register";
        }

        model.addAttribute("phone", user.getPhone());
        model.addAttribute("userId", userId);
        return "auth/register-phone-verify";
    }

    @PostMapping("/register-phone-skip")
    public String skipPhoneVerification(HttpSession session, RedirectAttributes redirectAttributes) {
        // XÃ³a session vÃ  chuyá»ƒn vá» login
        session.removeAttribute("newUserId");
        redirectAttributes.addFlashAttribute("message", "Báº¡n cÃ³ thá»ƒ xÃ¡c thá»±c sá»‘ Ä‘iá»‡n thoáº¡i sau trong pháº§n cÃ i Ä‘áº·t tÃ i khoáº£n.");
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
    // // Gá»­i OTP phone
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
    // // XÃ¡c thá»±c OTP
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
            errorResponse.put("message", "NgÆ°á»i dÃ¹ng chÆ°a Ä‘Äƒng nháº­p");
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
                response.put("message", "Loáº¡i xÃ¡c thá»±c khÃ´ng há»£p lá»‡");
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
            errorResponse.put("message", "NgÆ°á»i dÃ¹ng chÆ°a Ä‘Äƒng nháº­p");
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
