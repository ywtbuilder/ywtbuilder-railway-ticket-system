package com.railway.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("t_order_item")
public class OrderItem {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String orderSn;
    private Long userId;
    private String username;
    private Long trainId;
    private String carriageNumber;
    private Integer seatType;
    private String seatNumber;
    private String realName;
    private Integer idType;
    private String idCard;
    private Integer ticketType;
    private String phone;
    private Integer status;
    private Integer amount;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer delFlag;
}
