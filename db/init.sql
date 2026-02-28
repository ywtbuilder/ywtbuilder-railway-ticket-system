-- =============================================
-- 12306 V2 - 精简版数据库初始化脚本
-- 无分表，直连 MySQL
-- =============================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 用户表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_user` (
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `username`    varchar(256) NOT NULL COMMENT '用户名',
    `password`    varchar(512) NOT NULL COMMENT '密码',
    `real_name`   varchar(256) DEFAULT NULL COMMENT '真实姓名',
    `id_type`     int(3) DEFAULT NULL COMMENT '证件类型',
    `id_card`     varchar(256) DEFAULT NULL COMMENT '证件号',
    `phone`       varchar(128) DEFAULT NULL COMMENT '手机号',
    `mail`        varchar(256) DEFAULT NULL COMMENT '邮箱',
    `address`     varchar(512) DEFAULT NULL COMMENT '地址',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`    tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ----------------------------
-- 乘车人表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_passenger` (
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `username`    varchar(256) NOT NULL COMMENT '用户名',
    `real_name`   varchar(256) DEFAULT NULL COMMENT '真实姓名',
    `id_type`     int(3) DEFAULT NULL COMMENT '证件类型',
    `id_card`     varchar(256) DEFAULT NULL COMMENT '证件号',
    `discount_type` int(3) DEFAULT NULL COMMENT '优惠类型',
    `phone`       varchar(128) DEFAULT NULL COMMENT '手机号',
    `create_date` datetime DEFAULT NULL COMMENT '添加日期',
    `verify_status` int(3) DEFAULT 1 COMMENT '审核状态',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`    tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`),
    KEY `idx_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='乘车人表';

-- ----------------------------
-- 地区表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_region` (
    `id`           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`         varchar(64) DEFAULT NULL COMMENT '地区名称',
    `full_name`    varchar(64) DEFAULT NULL COMMENT '地区全名',
    `code`         varchar(64) DEFAULT NULL COMMENT '地区编码',
    `initial`      varchar(2) DEFAULT NULL COMMENT '地区首字母',
    `spell`        varchar(64) DEFAULT NULL COMMENT '拼音',
    `popular_flag` tinyint(1) DEFAULT NULL COMMENT '热门标识',
    `create_time`  datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`  datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`     tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='地区表';

-- ----------------------------
-- 车站表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_station` (
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `code`        varchar(64) DEFAULT NULL COMMENT '车站编号',
    `name`        varchar(256) DEFAULT NULL COMMENT '车站名称',
    `spell`       varchar(64) DEFAULT NULL COMMENT '拼音',
    `region`      varchar(64) DEFAULT NULL COMMENT '车站地区',
    `region_name` varchar(64) DEFAULT NULL COMMENT '车站地区名称',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`    tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='车站表';

-- ----------------------------
-- 列车表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_train` (
    `id`             bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `train_number`   varchar(256) DEFAULT NULL COMMENT '列车车次',
    `train_type`     int(3) DEFAULT NULL COMMENT '列车类型 0：高铁 1：动车 2：普通车',
    `train_tag`      varchar(32) DEFAULT NULL COMMENT '列车标签',
    `train_brand`    varchar(32) DEFAULT NULL COMMENT '列车品牌',
    `start_station`  varchar(256) DEFAULT NULL COMMENT '起始站',
    `end_station`    varchar(256) DEFAULT NULL COMMENT '终点站',
    `start_region`   varchar(256) DEFAULT NULL COMMENT '起始城市',
    `end_region`     varchar(256) DEFAULT NULL COMMENT '终点城市',
    `sale_time`      datetime DEFAULT NULL COMMENT '销售时间',
    `sale_status`    int(3) DEFAULT 0 COMMENT '销售状态 0：可售 1：不可售',
    `departure_time` datetime DEFAULT NULL COMMENT '出发时间',
    `arrival_time`   datetime DEFAULT NULL COMMENT '到达时间',
    `create_time`    datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`    datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`       tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='列车表';

-- ----------------------------
-- 列车站点表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_train_station` (
    `id`             bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `train_id`       bigint(20) DEFAULT NULL COMMENT '车次ID',
    `station_id`     bigint(20) DEFAULT NULL COMMENT '车站ID',
    `sequence`       varchar(32) DEFAULT NULL COMMENT '站点顺序',
    `departure`      varchar(64) DEFAULT NULL COMMENT '出发站点',
    `arrival`        varchar(64) DEFAULT NULL COMMENT '到达站点',
    `start_region`   varchar(256) DEFAULT NULL COMMENT '起始城市',
    `end_region`     varchar(256) DEFAULT NULL COMMENT '终点城市',
    `arrival_time`   datetime DEFAULT NULL COMMENT '到站时间',
    `departure_time` datetime DEFAULT NULL COMMENT '出站时间',
    `stopover_time`  int(3) DEFAULT NULL COMMENT '停留时间(分)',
    `create_time`    datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`    datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`       tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`),
    KEY `idx_train_id` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='列车站点表';

-- ----------------------------
-- 列车站点价格表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_train_station_price` (
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `train_id`    bigint(20) DEFAULT NULL COMMENT '车次ID',
    `departure`   varchar(64) DEFAULT NULL COMMENT '出发站点',
    `arrival`     varchar(64) DEFAULT NULL COMMENT '到达站点',
    `seat_type`   int(3) DEFAULT NULL COMMENT '座位类型',
    `price`       int(11) DEFAULT NULL COMMENT '车票价格(分)',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`    tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`),
    KEY `idx_train_id` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='列车站点价格表';

-- ----------------------------
-- 列车站点关系表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_train_station_relation` (
    `id`             bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `train_id`       bigint(20) DEFAULT NULL COMMENT '车次ID',
    `departure`      varchar(64) DEFAULT NULL COMMENT '出发站点',
    `arrival`        varchar(64) DEFAULT NULL COMMENT '到达站点',
    `start_region`   varchar(256) DEFAULT NULL COMMENT '起始城市名称',
    `end_region`     varchar(256) DEFAULT NULL COMMENT '终点城市名称',
    `departure_flag` tinyint(1) DEFAULT NULL COMMENT '始发标识',
    `arrival_flag`   tinyint(1) DEFAULT NULL COMMENT '终点标识',
    `departure_time` datetime DEFAULT NULL COMMENT '出发时间',
    `arrival_time`   datetime DEFAULT NULL COMMENT '到达时间',
    `create_time`    datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`    datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`       tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`),
    KEY `idx_train_id` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='列车站点关系表';

-- ----------------------------
-- 车厢表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_carriage` (
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `train_id`        bigint(20) DEFAULT NULL COMMENT '列车ID',
    `carriage_number` varchar(64) DEFAULT NULL COMMENT '车厢号',
    `carriage_type`   int(3) DEFAULT NULL COMMENT '车厢类型',
    `seat_count`      int(3) DEFAULT NULL COMMENT '座位数',
    `create_time`     datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`     datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`        tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`),
    KEY `idx_train_id` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='车厢表';

-- ----------------------------
-- 座位表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_seat` (
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `train_id`        bigint(20) DEFAULT NULL COMMENT '列车ID',
    `carriage_number` varchar(64) DEFAULT NULL COMMENT '车厢号',
    `seat_number`     varchar(64) DEFAULT NULL COMMENT '座位号',
    `seat_type`       int(3) DEFAULT NULL COMMENT '座位类型',
    `start_station`   varchar(256) DEFAULT NULL COMMENT '起始站',
    `end_station`     varchar(256) DEFAULT NULL COMMENT '终点站',
    `price`           int(11) DEFAULT NULL COMMENT '车票价格(分)',
    `seat_status`     int(3) DEFAULT 0 COMMENT '座位状态 0:可售 1:锁定 2:已售',
    `create_time`     datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`     datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`        tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`),
    KEY `idx_train_id` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='座位表';

-- ----------------------------
-- 车票表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_ticket` (
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `username`        varchar(256) DEFAULT NULL COMMENT '用户名',
    `train_id`        bigint(20) DEFAULT NULL COMMENT '列车ID',
    `carriage_number` varchar(64) DEFAULT NULL COMMENT '车厢号',
    `seat_number`     varchar(64) DEFAULT NULL COMMENT '座位号',
    `passenger_id`    bigint(20) DEFAULT NULL COMMENT '乘车人ID',
    `ticket_status`   int(3) DEFAULT NULL COMMENT '车票状态',
    `create_time`     datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`     datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`        tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='车票表';

-- ----------------------------
-- 订单表 (单表，不分表)
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_order` (
    `id`             bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_sn`       varchar(64) NOT NULL COMMENT '订单号',
    `user_id`        bigint(20) DEFAULT NULL COMMENT '用户ID',
    `username`       varchar(256) DEFAULT NULL COMMENT '用户名',
    `train_id`       bigint(20) DEFAULT NULL COMMENT '列车ID',
    `train_number`   varchar(256) DEFAULT NULL COMMENT '列车车次',
    `riding_date`    date DEFAULT NULL COMMENT '乘车日期',
    `departure`      varchar(64) DEFAULT NULL COMMENT '出发站点',
    `arrival`        varchar(64) DEFAULT NULL COMMENT '到达站点',
    `departure_time` datetime DEFAULT NULL COMMENT '出发时间',
    `arrival_time`   datetime DEFAULT NULL COMMENT '到达时间',
    `source`         int(3) DEFAULT 0 COMMENT '订单来源',
    `status`         int(3) DEFAULT 0 COMMENT '订单状态 0:待支付 10:已支付 20:已进站 30:待退票 40:已退票 50:已改签 60:已取消',
    `order_time`     datetime DEFAULT NULL COMMENT '下单时间',
    `pay_type`       int(3) DEFAULT NULL COMMENT '支付方式',
    `pay_time`       datetime DEFAULT NULL COMMENT '支付时间',
    `create_time`    datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`    datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`       tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_order_sn` (`order_sn`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- ----------------------------
-- 订单明细表 (单表)
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_order_item` (
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_sn`        varchar(64) DEFAULT NULL COMMENT '订单号',
    `user_id`         bigint(20) DEFAULT NULL COMMENT '用户ID',
    `username`        varchar(256) DEFAULT NULL COMMENT '用户名',
    `train_id`        bigint(20) DEFAULT NULL COMMENT '列车ID',
    `carriage_number` varchar(64) DEFAULT NULL COMMENT '车厢号',
    `seat_type`       int(3) DEFAULT NULL COMMENT '座位类型',
    `seat_number`     varchar(64) DEFAULT NULL COMMENT '座位号',
    `real_name`       varchar(256) DEFAULT NULL COMMENT '真实姓名',
    `id_type`         int(3) DEFAULT NULL COMMENT '证件类型',
    `id_card`         varchar(256) DEFAULT NULL COMMENT '证件号',
    `ticket_type`     int(3) DEFAULT NULL COMMENT '车票类型',
    `phone`           varchar(128) DEFAULT NULL COMMENT '手机号',
    `status`          int(3) DEFAULT 0 COMMENT '状态',
    `amount`          int(11) DEFAULT NULL COMMENT '金额(分)',
    `create_time`     datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`     datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`        tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`),
    KEY `idx_order_sn` (`order_sn`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单明细表';

-- ----------------------------
-- 支付表 (单表)
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_pay` (
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_sn`    varchar(64) DEFAULT NULL COMMENT '订单号',
    `pay_sn`      varchar(64) DEFAULT NULL COMMENT '支付流水号',
    `out_order_sn` varchar(128) DEFAULT NULL COMMENT '外部订单号',
    `channel`     int(3) DEFAULT NULL COMMENT '支付渠道',
    `trade_type`  int(3) DEFAULT NULL COMMENT '交易类型',
    `subject`     varchar(512) DEFAULT NULL COMMENT '订单标题',
    `order_request_id` varchar(64) DEFAULT NULL COMMENT '商户订单号',
    `total_amount` int(11) DEFAULT NULL COMMENT '交易金额(分)',
    `status`      int(3) DEFAULT 0 COMMENT '支付状态',
    `pay_time`    datetime DEFAULT NULL COMMENT '支付时间',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `del_flag`    tinyint(1) DEFAULT 0 COMMENT '删除标识',
    PRIMARY KEY (`id`),
    KEY `idx_order_sn` (`order_sn`),
    KEY `idx_pay_sn` (`pay_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付表';

-- =============================================
-- 初始数据
-- =============================================

-- 地区数据
INSERT INTO `t_region` (`id`, `name`, `full_name`, `code`, `initial`, `spell`, `popular_flag`) VALUES
(1, '北京', '北京市', 'BJP', 'B', 'beijing', 1),
(2, '上海', '上海市', 'SHH', 'S', 'shanghai', 1),
(3, '广州', '广州市', 'GZQ', 'G', 'guangzhou', 1),
(4, '深圳', '深圳市', 'SZQ', 'S', 'shenzhen', 1),
(5, '杭州', '杭州市', 'HZH', 'H', 'hangzhou', 1),
(6, '南京', '南京市', 'NJH', 'N', 'nanjing', 1),
(7, '长沙', '长沙市', 'CSQ', 'C', 'changsha', 1),
(8, '武汉', '武汉市', 'WHN', 'W', 'wuhan', 1);

-- 车站数据
INSERT INTO `t_station` (`id`, `code`, `name`, `spell`, `region`, `region_name`) VALUES
(1, 'BJP', '北京南', 'beijingnan', 'BJP', '北京'),
(2, 'SHH', '上海虹桥', 'shanghaihongqiao', 'SHH', '上海'),
(3, 'GZQ', '广州南', 'guangzhounan', 'GZQ', '广州'),
(4, 'SZQ', '深圳北', 'shenzhenbei', 'SZQ', '深圳'),
(5, 'HZH', '杭州东', 'hangzhoudong', 'HZH', '杭州'),
(6, 'NJH', '南京南', 'nanjingnan', 'NJH', '南京'),
(7, 'CSQ', '长沙南', 'changshanan', 'CSQ', '长沙'),
(8, 'WHN', '武汉', 'wuhan', 'WHN', '武汉'),
(9, 'JNK', '济南西', 'jinanxi', 'JNK', '济南'),
(10, 'TJP', '天津南', 'tianjinnan', 'TJP', '天津'),
(11, 'XAY', '西安北', 'xianbei', 'XAY', '西安');

-- 列车数据
INSERT INTO `t_train` (`id`, `train_number`, `train_type`, `train_tag`, `train_brand`, `start_station`, `end_station`, `start_region`, `end_region`, `sale_status`, `departure_time`, `arrival_time`) VALUES
(1, 'G35', 0, '0', '0', '北京南', '杭州东', '北京', '杭州', 0, '2026-02-20 07:20:00', '2026-02-20 12:40:00'),
(2, 'G39', 0, '0', '0', '北京南', '杭州东', '北京', '杭州', 0, '2026-02-20 09:00:00', '2026-02-20 14:08:00'),
(3, 'G57', 0, '0,6', '0', '北京南', '杭州东', '北京', '杭州', 0, '2026-02-20 11:15:00', '2026-02-20 16:42:00'),
(4, 'G165', 1, '1', '1', '北京南', '杭州东', '北京', '杭州', 0, '2026-02-20 14:30:00', '2026-02-20 20:55:00');

-- 列车站点关系
INSERT INTO `t_train_station_relation` (`train_id`, `departure`, `arrival`, `start_region`, `end_region`, `departure_flag`, `arrival_flag`, `departure_time`, `arrival_time`) VALUES
(1, '北京南', '杭州东', '北京', '杭州', 1, 1, '2026-02-20 07:20:00', '2026-02-20 12:40:00'),
(1, '北京南', '济南西', '北京', '济南', 1, 0, '2026-02-20 07:20:00', '2026-02-20 08:43:00'),
(1, '北京南', '南京南', '北京', '南京', 1, 0, '2026-02-20 07:20:00', '2026-02-20 10:56:00'),
(1, '济南西', '杭州东', '济南', '杭州', 0, 1, '2026-02-20 08:45:00', '2026-02-20 12:40:00'),
(1, '南京南', '杭州东', '南京', '杭州', 0, 1, '2026-02-20 10:58:00', '2026-02-20 12:40:00'),
(2, '北京南', '杭州东', '北京', '杭州', 1, 1, '2026-02-20 09:00:00', '2026-02-20 14:08:00'),
(2, '北京南', '南京南', '北京', '南京', 1, 0, '2026-02-20 09:00:00', '2026-02-20 11:52:00'),
(2, '南京南', '杭州东', '南京', '杭州', 0, 1, '2026-02-20 11:55:00', '2026-02-20 14:08:00'),
(3, '北京南', '杭州东', '北京', '杭州', 1, 1, '2026-02-20 11:15:00', '2026-02-20 16:42:00'),
(4, '北京南', '杭州东', '北京', '杭州', 1, 1, '2026-02-20 14:30:00', '2026-02-20 20:55:00');

-- 列车站点详情
INSERT INTO `t_train_station` (`train_id`, `sequence`, `departure`, `arrival`, `start_region`, `end_region`, `departure_time`, `arrival_time`, `stopover_time`) VALUES
(1, '01', '北京南', '北京南', '北京', '北京', '2026-02-20 07:20:00', '2026-02-20 07:20:00', 0),
(1, '02', '济南西', '济南西', '济南', '济南', '2026-02-20 08:45:00', '2026-02-20 08:43:00', 2),
(1, '03', '南京南', '南京南', '南京', '南京', '2026-02-20 10:58:00', '2026-02-20 10:56:00', 2),
(1, '04', '杭州东', '杭州东', '杭州', '杭州', '2026-02-20 12:40:00', '2026-02-20 12:40:00', 0),
(2, '01', '北京南', '北京南', '北京', '北京', '2026-02-20 09:00:00', '2026-02-20 09:00:00', 0),
(2, '02', '南京南', '南京南', '南京', '南京', '2026-02-20 11:55:00', '2026-02-20 11:52:00', 3),
(2, '03', '杭州东', '杭州东', '杭州', '杭州', '2026-02-20 14:08:00', '2026-02-20 14:08:00', 0),
(3, '01', '北京南', '北京南', '北京', '北京', '2026-02-20 11:15:00', '2026-02-20 11:15:00', 0),
(3, '02', '杭州东', '杭州东', '杭州', '杭州', '2026-02-20 16:42:00', '2026-02-20 16:42:00', 0),
(4, '01', '北京南', '北京南', '北京', '北京', '2026-02-20 14:30:00', '2026-02-20 14:30:00', 0),
(4, '02', '杭州东', '杭州东', '杭州', '杭州', '2026-02-20 20:55:00', '2026-02-20 20:55:00', 0);

-- 列车站点价格 (座位类型: 0-商务座 1-一等座 2-二等座 3-动卧 4-高级软卧 5-软卧 6-硬卧 7-软座 8-硬座 9-无座 13-其他)
INSERT INTO `t_train_station_price` (`train_id`, `departure`, `arrival`, `seat_type`, `price`) VALUES
(1, '北京南', '杭州东', 0, 263050),
(1, '北京南', '杭州东', 1, 90650),
(1, '北京南', '杭州东', 2, 53850),
(1, '北京南', '济南西', 2, 18450),
(1, '北京南', '济南西', 1, 31050),
(1, '北京南', '南京南', 2, 36550),
(1, '北京南', '南京南', 1, 61150),
(2, '北京南', '杭州东', 0, 263050),
(2, '北京南', '杭州东', 1, 90650),
(2, '北京南', '杭州东', 2, 53850),
(3, '北京南', '杭州东', 0, 263050),
(3, '北京南', '杭州东', 1, 90650),
(3, '北京南', '杭州东', 2, 53850),
(4, '北京南', '杭州东', 1, 90650),
(4, '北京南', '杭州东', 2, 53850);

-- 车厢数据 (G35)
INSERT INTO `t_carriage` (`train_id`, `carriage_number`, `carriage_type`, `seat_count`) VALUES
(1, '01', 0, 28),
(1, '02', 1, 56),
(1, '03', 1, 56),
(1, '04', 2, 90),
(1, '05', 2, 90),
(1, '06', 2, 90),
(1, '07', 2, 90),
(1, '08', 2, 90),
(2, '01', 0, 28),
(2, '02', 1, 56),
(2, '03', 2, 90),
(2, '04', 2, 90),
(3, '01', 0, 28),
(3, '02', 1, 56),
(3, '03', 2, 90),
(4, '01', 1, 56),
(4, '02', 2, 90),
(4, '03', 2, 90);

-- 测试用户
INSERT INTO `t_user` (`username`, `password`, `real_name`, `id_type`, `id_card`, `phone`, `mail`) VALUES
('admin', '$2a$10$dXJ3SW6G7P50lGmMkkmWZOBkCOKa5FJRqDOmKzjIXbN/yFYDQoRBu', '管理员', 0, '110101199001011234', '13800138000', 'admin@12306.cn');

SET FOREIGN_KEY_CHECKS = 1;
