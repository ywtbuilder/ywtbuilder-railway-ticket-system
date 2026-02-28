package com.railway.common;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.railway.entity.User;
import com.railway.mapper.UserMapper;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UserMapper userMapper;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public DataInitializer(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @Override
    public void run(String... args) {
        // Encode any plaintext passwords in the database
        User admin = userMapper.selectOne(
            new LambdaQueryWrapper<User>().eq(User::getUsername, "admin")
        );
        if (admin != null && admin.getPassword() != null) {
            String pwd = admin.getPassword();
            // Check if it's NOT already BCrypt-encoded
            if (!pwd.startsWith("$2a$") && !pwd.startsWith("$2b$")) {
                // Strip "PLAINTEXT:" prefix if present
                String raw = pwd.startsWith("PLAINTEXT:") ? pwd.substring(10) : pwd;
                String hashed = passwordEncoder.encode(raw);
                admin.setPassword(hashed);
                userMapper.updateById(admin);
                System.out.println("[DataInit] Demo user 'admin' password BCrypt-encoded successfully");
            } else {
                System.out.println("[DataInit] Demo user 'admin' password already BCrypt-encoded, skipping");
            }
        }
    }
}
