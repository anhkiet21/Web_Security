// package com.proj.webprojrct.common.config.security;

// import jakarta.servlet.ServletException;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import org.springframework.security.core.AuthenticationException;
// import org.springframework.security.web.AuthenticationEntryPoint;
// import org.springframework.stereotype.Component;

// import java.io.IOException;
// import java.nio.charset.StandardCharsets;

// @Component
// public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {

//     @Override
//     public void commence(HttpServletRequest request,
//             HttpServletResponse response,
//             AuthenticationException authException) throws IOException, ServletException {

//         String accept = request.getHeader("Accept");
//         String referer = request.getHeader("Referer");
//         boolean expectsHtml = accept != null && accept.contains("text/html");

//         if (expectsHtml) {
//             // redirect to login page; preserve original page in query if referer exists
//             String loginUrl = request.getContextPath() + "/login";
//             if (referer != null && !referer.isBlank()) {
//                 loginUrl += "?redirect=" + java.net.URLEncoder.encode(referer, StandardCharsets.UTF_8);
//             }
//             response.sendRedirect(loginUrl);
//             return;
//         }

//         // API client -> JSON 401
//         response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//         response.setContentType("application/json;charset=UTF-8");
//         String json = "{\"error\":\"unauthorized\",\"message\":\"Authentication required.\"}";
//         response.getOutputStream().write(json.getBytes(StandardCharsets.UTF_8));
//     }
// }
