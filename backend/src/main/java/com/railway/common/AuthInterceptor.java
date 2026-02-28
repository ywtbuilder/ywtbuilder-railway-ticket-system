package com.railway.common;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        // OPTIONS requests pass through
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String token = request.getHeader("Authorization");
        if (token != null && !token.isEmpty()) {
            if (jwtUtil.isTokenValid(token)) {
                String username = jwtUtil.getUsername(token);
                Long userId = jwtUtil.getUserId(token);
                request.setAttribute("username", username);
                request.setAttribute("userId", userId);
            }
        }
        // Always allow through - individual endpoints decide if auth is required
        return true;
    }
}
