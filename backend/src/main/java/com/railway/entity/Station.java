package com.railway.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("t_station")
public class Station {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String code;
    private String name;
    private String spell;
    private String region;
    private String regionName;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer delFlag;
}
