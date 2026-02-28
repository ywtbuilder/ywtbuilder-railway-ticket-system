package com.railway.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.railway.common.Result;
import com.railway.entity.Passenger;
import com.railway.mapper.PassengerMapper;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class PassengerController {

    private final PassengerMapper passengerMapper;

    @GetMapping("/api/user-service/passenger/query")
    public Result<?> queryPassengers(@RequestParam String username) {
        List<Passenger> list = passengerMapper.selectList(
                new LambdaQueryWrapper<Passenger>().eq(Passenger::getUsername, username));
        return Result.success(list);
    }

    @PostMapping("/api/user-service/passenger/save")
    public Result<?> savePassenger(@RequestBody Passenger passenger, HttpServletRequest request) {
        String username = (String) request.getAttribute("username");
        passenger.setUsername(username);
        passenger.setCreateDate(LocalDateTime.now());
        passenger.setVerifyStatus(1);
        passengerMapper.insert(passenger);
        return Result.success(null);
    }

    @PostMapping("/api/user-service/passenger/update")
    public Result<?> updatePassenger(@RequestBody Passenger passenger) {
        passengerMapper.updateById(passenger);
        return Result.success(null);
    }

    @PostMapping("/api/user-service/passenger/remove")
    public Result<?> removePassenger(@RequestBody Passenger passenger) {
        passengerMapper.deleteById(passenger.getId());
        return Result.success(null);
    }
}
