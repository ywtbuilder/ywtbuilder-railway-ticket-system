package com.railway.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.railway.common.Result;
import com.railway.entity.Pay;
import com.railway.mapper.PayMapper;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class PayController {

    private final PayMapper payMapper;

    @PostMapping("/api/pay-service/pay/create")
    public Result<?> createPay(@RequestBody PayCreateRequest req) {
        Pay pay = new Pay();
        pay.setOrderSn(req.getOrderSn());
        pay.setPaySn("PAY" + System.currentTimeMillis());
        pay.setChannel(req.getChannel());
        pay.setTradeType(req.getTradeType());
        pay.setSubject(req.getSubject());
        pay.setTotalAmount(req.getTotalAmount());
        pay.setStatus(0);
        payMapper.insert(pay);

        // Simulate immediate payment success for demo
        pay.setStatus(1);
        pay.setPayTime(LocalDateTime.now());
        payMapper.updateById(pay);

        Map<String, Object> result = new HashMap<>();
        result.put("paySn", pay.getPaySn());
        result.put("status", 1);
        return Result.success(result);
    }

    @GetMapping("/api/pay-service/pay/query/order-sn")
    public Result<?> queryPayByOrderSn(@RequestParam String orderSn) {
        Pay pay = payMapper.selectOne(
                new LambdaQueryWrapper<Pay>().eq(Pay::getOrderSn, orderSn));
        if (pay == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("status", 0);
            return Result.success(result);
        }
        return Result.success(pay);
    }

    @Data
    public static class PayCreateRequest {
        private String orderSn;
        private Integer channel;
        private Integer tradeType;
        private String subject;
        private Integer totalAmount;
    }
}
