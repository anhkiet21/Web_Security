// package com.proj.webprojrct.common.config.security;

// import jakarta.servlet.ServletException;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import org.springframework.security.access.AccessDeniedException;
// import org.springframework.security.web.access.AccessDeniedHandler;
// import org.springframework.stereotype.Component;

// import java.io.IOException;
// import java.nio.charset.StandardCharsets;

// @Component
// public class CustomAccessDeniedHandler implements AccessDeniedHandler {

//     @Override
//     public void handle(HttpServletRequest request,
//             HttpServletResponse response,
//             AccessDeniedException accessDeniedException) throws IOException, ServletException {

//         String accept = request.getHeader("Accept");
//         String referer = request.getHeader("Referer");

//         boolean expectsHtml = accept != null && accept.contains("text/html");

//         if (expectsHtml) {
//             if (referer != null && !referer.isBlank()) {
//                 response.sendRedirect(referer);
//             } else {
//                 response.sendRedirect(request.getContextPath() + "/");
//             }
//             return;
//         }

//         // API client -> JSON 403
//         response.setStatus(HttpServletResponse.SC_FORBIDDEN);
//         response.setContentType("application/json;charset=UTF-8");
//         String json = "{\"error\":\"access_denied\",\"message\":\"You do not have permission to access this resource.\"}";
//         response.getOutputStream().write(json.getBytes(StandardCharsets.UTF_8));
//     }
// }
