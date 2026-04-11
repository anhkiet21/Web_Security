package com.proj.webprojrct.common.config.security;

import lombok.RequiredArgsConstructor;
import com.proj.webprojrct.common.config.security.JwtAuthenticationFilter;

import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import com.proj.webprojrct.auth.service.CustomOauth2UserService;
import com.proj.webprojrct.auth.service.OAuth2AuthenticationFailureHandler;
import com.proj.webprojrct.auth.service.OAuth2AuthenticationSuccessHandler;
import org.springframework.http.HttpMethod;
import org.springframework.core.annotation.Order;
import org.springframework.beans.factory.annotation.Autowired;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final CustomUserDetailsService uds;
    private final PasswordEncoder passwordEncoder;
    private final JwtAuthenticationFilter jwtFilter;
    // private final CustomAccessDeniedHandler accessDeniedHandler;
    // private final CustomAuthenticationEntryPoint authenticationEntryPoint;

    @Autowired(required = false)
    private CustomOauth2UserService customOauth2UserService;

    @Autowired(required = false)
    private OAuth2AuthenticationFailureHandler oAuth2AuthenticationFailureHandler;

    @Autowired(required = false)
    private OAuth2AuthenticationSuccessHandler oauth2SuccessHandler;

    public SecurityConfig(
            CustomUserDetailsService uds,
            PasswordEncoder passwordEncoder,
            JwtAuthenticationFilter jwtFilter
    // CustomAccessDeniedHandler accessDeniedHandler,
    // CustomAuthenticationEntryPoint authenticationEntryPoint
    ) {
        this.uds = uds;
        this.passwordEncoder = passwordEncoder;
        this.jwtFilter = jwtFilter;
        // this.accessDeniedHandler = accessDeniedHandler;
        // this.authenticationEntryPoint = authenticationEntryPoint;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/oauth2/**", "/login", "/dologin", "/register", "/doregister", "/doResetPassword", "/resetPassword", "/refresh", "/home", "/about", "/product/**", "/products", "/shop", "/deals", "/css/**", "/js/**", "/fonts/**", "/img/**", "/image/**", "/uploads/**", "/favicon.ico", "/error", "/error/**", "/webjars/**", "/WEB-INF/views/**", "/WEB-INF/decorators/**", "/common/**").permitAll()
                .requestMatchers("/api/products/**", "/api/categories/**", "/api/media/**", "/api/cart/**", "/api/favorite/**", "/api/documents/**", "/api/reviews/**").permitAll()
                .requestMatchers("/about", "/faq", "/warranty", "/return", "/payment", "/shipping", "/contact").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/seller/**").hasAnyRole("SELLER", "ADMIN")
                // .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN", "SELLER")
                .anyRequest().authenticated()
                )
                // .exceptionHandling(e -> e
                // .accessDeniedHandler(accessDeniedHandler)
                // .authenticationEntryPoint(authenticationEntryPoint)
                // )
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
                .formLogin(form -> form.disable())
                .httpBasic(httpBasic -> httpBasic.disable());

        // Only configure OAuth2 if beans are available
        if (customOauth2UserService != null && oauth2SuccessHandler != null && oAuth2AuthenticationFailureHandler != null) {
            http.oauth2Login(oauth2 -> oauth2
                    .loginPage("/login")
                    .defaultSuccessUrl("/", true)
                    .userInfoEndpoint(userInfo -> userInfo.userService(customOauth2UserService))
                    .successHandler(oauth2SuccessHandler)
                    .failureHandler(oAuth2AuthenticationFailureHandler)
            );
        }

        return http.build();
    }

    @Bean
    public DaoAuthenticationProvider daoAuthProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(uds);
        provider.setPasswordEncoder(passwordEncoder);
        return provider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }
}
