package com.railway.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("t_order")
public class Order {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String orderSn;
    private Long userId;
    private String username;
    private Long trainId;
    private String trainNumber;
    private LocalDate ridingDate;
    private String departure;
    private String arrival;
    private LocalDateTime departureTime;
    private LocalDateTime arrivalTime;
    private Integer source;
    private Integer status;
    private LocalDateTime orderTime;
    private Integer payType;
    private LocalDateTime payTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer delFlag;
}
