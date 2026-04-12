package com.proj.webprojrct.auth.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.proj.webprojrct.auth.dto.request.RegisterRequest;
import com.proj.webprojrct.auth.service.Oauth2RegistrationService;
import com.proj.webprojrct.auth.service.AuthService;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.common.config.security.JwtUtil;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/oauth2")
public class Oauth2RegistrationController {

    private final Oauth2RegistrationService registrationService;
    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final AuthService authService;

    /**
     * Hiá»ƒn thá»‹ form nháº­p thÃ´ng tin bá»• sung khi OAuth2 user chÆ°a tá»“n táº¡i
     */
    @GetMapping("/complete")
    public String showCompleteForm(HttpServletResponse response,
            HttpSession session,
            Model model) {
        String email = (String) session.getAttribute("oauth2_email");
        String name = (String) session.getAttribute("oauth2_name");
        String picture = (String) session.getAttribute("oauth2_picture");

        if (email == null) {
            return "redirect:/login";
        }
        // Kiá»ƒm tra user Ä‘Ã£ tá»“n táº¡i chÆ°a
        User user = userRepository.findByEmail(email).orElse(null);
        if (user != null) {
            String accessToken = jwtUtil.generateAccessToken(user);
            String refreshToken = jwtUtil.generateRefreshToken(user);

            // LÆ°u refresh token vÃ o database
            authService.saveRefreshToken(user.getPhone(), refreshToken);

            Cookie accessCookie = new Cookie("access_token", accessToken);
            accessCookie.setHttpOnly(true);
            accessCookie.setPath("/");
            response.addCookie(accessCookie);

            Cookie refreshCookie = new Cookie("refresh_token", refreshToken);
            refreshCookie.setHttpOnly(true);
            refreshCookie.setPath("/");
            response.addCookie(refreshCookie);

            session.removeAttribute("oauth2_email");
            session.removeAttribute("oauth2_name");
            session.removeAttribute("oauth2_picture");
            return "redirect:/";
        }

        model.addAttribute("email", email);
        model.addAttribute("name", name);
        model.addAttribute("picture", picture);

        return "auth/oauth2_complete_form";
    }

    @PostMapping("/complete")
    public String completeRegistration(HttpSession session,
            HttpServletResponse response,
            Model model,
            @RequestParam String fullName,
            @RequestParam String phone,
            @RequestParam(required = false) String address) {

        String email = (String) session.getAttribute("oauth2_email");
        String name = (String) session.getAttribute("oauth2_name");
        String picture = (String) session.getAttribute("oauth2_picture");

        if (email == null) {
            return "redirect:/login";
        }

        RegisterRequest request = new RegisterRequest();
        request.setEmail(email);
        request.setFullName(fullName);
        request.setPhone(phone);
        request.setAddress(address);

        try {
            // Service sáº½ táº¡o random password vÃ  lÆ°u user
            User user = registrationService.registerNewUser(request);

            // Generate JWT ngay sau khi táº¡o user
            String accessToken = jwtUtil.generateAccessToken(user);
            String refreshToken = jwtUtil.generateRefreshToken(user);

            // LÆ°u refresh token vÃ o database
            authService.saveRefreshToken(user.getPhone(), refreshToken);

            Cookie accessCookie = new Cookie("access_token", accessToken);
            accessCookie.setHttpOnly(true);
            accessCookie.setPath("/");
            response.addCookie(accessCookie);

            Cookie refreshCookie = new Cookie("refresh_token", refreshToken);
            refreshCookie.setHttpOnly(true);
            refreshCookie.setPath("/");
            response.addCookie(refreshCookie);

            // XÃ³a session OAuth2 táº¡m
            session.removeAttribute("oauth2_email");
            session.removeAttribute("oauth2_name");
            session.removeAttribute("oauth2_picture");

            // LÆ°u userId vÃ o session Ä‘á»ƒ trang verify biáº¿t
            session.setAttribute("newUserId", user.getId());

            // Chuyá»ƒn Ä‘áº¿n trang xÃ¡c thá»±c phone (giá»‘ng nhÆ° Ä‘Äƒng kÃ½ thÆ°á»ng)
            return "redirect:/register-phone-verify";
        } catch (RuntimeException e) {
            // Xá»­ lÃ½ lá»—i (email hoáº·c phone Ä‘Ã£ tá»“n táº¡i)
            model.addAttribute("error", e.getMessage());
            model.addAttribute("email", email);
            model.addAttribute("name", name);
            model.addAttribute("picture", picture);

            // Giá»¯ láº¡i dá»¯ liá»‡u ngÆ°á»i dÃ¹ng Ä‘Ã£ nháº­p
            model.addAttribute("fullName", fullName);
            model.addAttribute("phone", phone);
            model.addAttribute("address", address);

            return "auth/oauth2_complete_form";
        }
    }

}
