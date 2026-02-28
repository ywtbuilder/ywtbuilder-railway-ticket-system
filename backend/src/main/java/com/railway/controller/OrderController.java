package com.railway.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.railway.common.Result;
import com.railway.entity.Order;
import com.railway.entity.OrderItem;
import com.railway.mapper.OrderMapper;
import com.railway.mapper.OrderItemMapper;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class OrderController {

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;

    @GetMapping("/api/order-service/order/ticket/query")
    public Result<?> queryOrder(@RequestParam String orderSn) {
        Order order = orderMapper.selectOne(
                new LambdaQueryWrapper<Order>().eq(Order::getOrderSn, orderSn));
        if (order == null) {
            return Result.error("订单不存在");
        }

        List<OrderItem> items = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderSn, orderSn));

        Map<String, Object> result = new HashMap<>();
        result.put("order", order);
        result.put("passengerDetails", items);
        return Result.success(result);
    }

    @GetMapping("/api/order-service/order/ticket/page")
    public Result<?> pageOrders(
            @RequestParam(required = false) Long userId,
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            HttpServletRequest request) {

        Long uid = userId != null ? userId : (Long) request.getAttribute("userId");
        Page<Order> page = new Page<>(current, size);

        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        if (uid != null) {
            wrapper.eq(Order::getUserId, uid);
        }
        wrapper.orderByDesc(Order::getCreateTime);

        orderMapper.selectPage(page, wrapper);

        Map<String, Object> result = new HashMap<>();
        result.put("records", page.getRecords());
        result.put("total", page.getTotal());
        result.put("current", page.getCurrent());
        result.put("size", page.getSize());
        return Result.success(result);
    }

    @GetMapping("/api/order-service/order/ticket/self/page")
    public Result<?> selfPageOrders(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            HttpServletRequest request) {

        Long uid = (Long) request.getAttribute("userId");
        Page<Order> page = new Page<>(current, size);

        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        if (uid != null) {
            wrapper.eq(Order::getUserId, uid);
        }
        wrapper.orderByDesc(Order::getCreateTime);

        orderMapper.selectPage(page, wrapper);

        Map<String, Object> result = new HashMap<>();
        result.put("records", page.getRecords());
        result.put("total", page.getTotal());
        result.put("current", page.getCurrent());
        result.put("size", page.getSize());
        return Result.success(result);
    }
}
