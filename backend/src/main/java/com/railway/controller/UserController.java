package com.railway.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.railway.common.BizException;
import com.railway.common.JwtUtil;
import com.railway.common.Result;
import com.railway.entity.User;
import com.railway.mapper.UserMapper;
import jakarta.servlet.http.HttpServletRequest;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class UserController {

    private final UserMapper userMapper;
    private final JwtUtil jwtUtil;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @PostMapping("/api/user-service/v1/login")
    public Result<?> login(@RequestBody LoginRequest req) {
        User user = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getUsername, req.getUsername()));
        if (user == null) {
            throw new BizException("用户不存在");
        }
        if (!passwordEncoder.matches(req.getPassword(), user.getPassword())) {
            throw new BizException("密码错误");
        }
        String token = jwtUtil.generateToken(user.getId(), user.getUsername());

        Map<String, Object> data = new HashMap<>();
        data.put("userId", user.getId());
        data.put("username", user.getUsername());
        data.put("realName", user.getRealName());
        data.put("accessToken", token);
        return Result.success(data);
    }

    @PostMapping("/api/user-service/register")
    public Result<?> register(@RequestBody RegisterRequest req) {
        User exists = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getUsername, req.getUsername()));
        if (exists != null) {
            throw new BizException("用户名已存在");
        }
        User user = new User();
        user.setUsername(req.getUsername());
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        user.setRealName(req.getRealName());
        user.setIdType(req.getIdType());
        user.setIdCard(req.getIdCard());
        user.setPhone(req.getPhone());
        user.setMail(req.getMail());
        userMapper.insert(user);
        return Result.success(null);
    }

    @GetMapping("/api/user-service/query")
    public Result<?> queryUser(@RequestParam String username) {
        User user = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getUsername, username));
        if (user == null) {
            throw new BizException("用户不存在");
        }
        user.setPassword(null); // hide password
        return Result.success(user);
    }

    @PostMapping("/api/user-service/update")
    public Result<?> updateUser(@RequestBody User user, HttpServletRequest request) {
        String username = (String) request.getAttribute("username");
        if (username == null)
            throw new BizException("请先登录");

        User existing = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getUsername, username));
        if (existing == null)
            throw new BizException("用户不存在");

        existing.setRealName(user.getRealName());
        existing.setPhone(user.getPhone());
        existing.setMail(user.getMail());
        existing.setAddress(user.getAddress());
        existing.setIdType(user.getIdType());
        existing.setIdCard(user.getIdCard());
        userMapper.updateById(existing);
        return Result.success(null);
    }

    @GetMapping("/api/user-service/logout")
    public Result<?> logout() {
        return Result.success(null);
    }

    @Data
    public static class LoginRequest {
        private String username;
        private String password;
    }

    @Data
    public static class RegisterRequest {
        private String username;
        private String password;
        private String realName;
        private Integer idType;
        private String idCard;
        private String phone;
        private String mail;
    }
}
