-- Seed data for 12306 V2

-- Test user (password: admin123, will be BCrypt-encoded on startup by DataInitializer)
INSERT INTO t_user (username, password, real_name, id_type, id_card, phone, mail) VALUES
('admin', 'PLAINTEXT:admin123', '管理员', 0, '110101199001011234', '13800138000', 'admin@12306.cn');

-- Stations
INSERT INTO t_station (id, code, name, spell, region, region_name) VALUES
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

-- Regions
INSERT INTO t_region (name, full_name, code, initial, spell, popular_flag) VALUES
('北京', '北京市', 'BJP', 'B', 'beijing', 1),
('上海', '上海市', 'SHH', 'S', 'shanghai', 1),
('广州', '广州市', 'GZQ', 'G', 'guangzhou', 1),
('深圳', '深圳市', 'SZQ', 'S', 'shenzhen', 1),
('杭州', '杭州市', 'HZH', 'H', 'hangzhou', 1),
('南京', '南京市', 'NJH', 'N', 'nanjing', 1),
('长沙', '长沙市', 'CSQ', 'C', 'changsha', 1),
('武汉', '武汉市', 'WHN', 'W', 'wuhan', 1);

-- Trains (Beijing -> Hangzhou)
INSERT INTO t_train (id, train_number, train_type, train_tag, train_brand, start_station, end_station, start_region, end_region, sale_status, departure_time, arrival_time) VALUES
(1, 'G35', 0, '0', '0', '北京南', '杭州东', '北京', '杭州', 0, TIMESTAMP '2026-02-20 07:20:00', TIMESTAMP '2026-02-20 12:40:00'),
(2, 'G39', 0, '0', '0', '北京南', '杭州东', '北京', '杭州', 0, TIMESTAMP '2026-02-20 09:00:00', TIMESTAMP '2026-02-20 14:08:00'),
(3, 'G57', 0, '0,6', '0', '北京南', '杭州东', '北京', '杭州', 0, TIMESTAMP '2026-02-20 11:15:00', TIMESTAMP '2026-02-20 16:42:00'),
(4, 'G165', 1, '1', '1', '北京南', '杭州东', '北京', '杭州', 0, TIMESTAMP '2026-02-20 14:30:00', TIMESTAMP '2026-02-20 20:55:00');

-- Trains (Beijing -> Shanghai)
INSERT INTO t_train (id, train_number, train_type, train_tag, train_brand, start_station, end_station, start_region, end_region, sale_status, departure_time, arrival_time) VALUES
(5, 'G1', 0, '0,6', '0', '北京南', '上海虹桥', '北京', '上海', 0, TIMESTAMP '2026-02-20 07:00:00', TIMESTAMP '2026-02-20 11:36:00'),
(6, 'G3', 0, '0', '0', '北京南', '上海虹桥', '北京', '上海', 0, TIMESTAMP '2026-02-20 09:00:00', TIMESTAMP '2026-02-20 13:28:00'),
(7, 'G5', 0, '0', '0', '北京南', '上海虹桥', '北京', '上海', 0, TIMESTAMP '2026-02-20 10:00:00', TIMESTAMP '2026-02-20 14:28:00');

-- Train station relations (Beijing -> Hangzhou)
INSERT INTO t_train_station_relation (train_id, departure, arrival, start_region, end_region, departure_flag, arrival_flag, departure_time, arrival_time) VALUES
(1, '北京南', '杭州东', '北京', '杭州', 1, 1, TIMESTAMP '2026-02-20 07:20:00', TIMESTAMP '2026-02-20 12:40:00'),
(1, '北京南', '济南西', '北京', '济南', 1, 0, TIMESTAMP '2026-02-20 07:20:00', TIMESTAMP '2026-02-20 08:43:00'),
(1, '北京南', '南京南', '北京', '南京', 1, 0, TIMESTAMP '2026-02-20 07:20:00', TIMESTAMP '2026-02-20 10:56:00'),
(2, '北京南', '杭州东', '北京', '杭州', 1, 1, TIMESTAMP '2026-02-20 09:00:00', TIMESTAMP '2026-02-20 14:08:00'),
(3, '北京南', '杭州东', '北京', '杭州', 1, 1, TIMESTAMP '2026-02-20 11:15:00', TIMESTAMP '2026-02-20 16:42:00'),
(4, '北京南', '杭州东', '北京', '杭州', 1, 1, TIMESTAMP '2026-02-20 14:30:00', TIMESTAMP '2026-02-20 20:55:00');

-- Train station relations (Beijing -> Shanghai)
INSERT INTO t_train_station_relation (train_id, departure, arrival, start_region, end_region, departure_flag, arrival_flag, departure_time, arrival_time) VALUES
(5, '北京南', '上海虹桥', '北京', '上海', 1, 1, TIMESTAMP '2026-02-20 07:00:00', TIMESTAMP '2026-02-20 11:36:00'),
(6, '北京南', '上海虹桥', '北京', '上海', 1, 1, TIMESTAMP '2026-02-20 09:00:00', TIMESTAMP '2026-02-20 13:28:00'),
(7, '北京南', '上海虹桥', '北京', '上海', 1, 1, TIMESTAMP '2026-02-20 10:00:00', TIMESTAMP '2026-02-20 14:28:00');

-- Train stations (stops)
INSERT INTO t_train_station (train_id, sequence, departure, arrival, start_region, end_region, departure_time, arrival_time, stopover_time) VALUES
(1, '01', '北京南', '北京南', '北京', '北京', TIMESTAMP '2026-02-20 07:20:00', TIMESTAMP '2026-02-20 07:20:00', 0),
(1, '02', '济南西', '济南西', '济南', '济南', TIMESTAMP '2026-02-20 08:45:00', TIMESTAMP '2026-02-20 08:43:00', 2),
(1, '03', '南京南', '南京南', '南京', '南京', TIMESTAMP '2026-02-20 10:58:00', TIMESTAMP '2026-02-20 10:56:00', 2),
(1, '04', '杭州东', '杭州东', '杭州', '杭州', TIMESTAMP '2026-02-20 12:40:00', TIMESTAMP '2026-02-20 12:40:00', 0),
(2, '01', '北京南', '北京南', '北京', '北京', TIMESTAMP '2026-02-20 09:00:00', TIMESTAMP '2026-02-20 09:00:00', 0),
(2, '02', '南京南', '南京南', '南京', '南京', TIMESTAMP '2026-02-20 11:55:00', TIMESTAMP '2026-02-20 11:52:00', 3),
(2, '03', '杭州东', '杭州东', '杭州', '杭州', TIMESTAMP '2026-02-20 14:08:00', TIMESTAMP '2026-02-20 14:08:00', 0),
(3, '01', '北京南', '北京南', '北京', '北京', TIMESTAMP '2026-02-20 11:15:00', TIMESTAMP '2026-02-20 11:15:00', 0),
(3, '02', '杭州东', '杭州东', '杭州', '杭州', TIMESTAMP '2026-02-20 16:42:00', TIMESTAMP '2026-02-20 16:42:00', 0),
(4, '01', '北京南', '北京南', '北京', '北京', TIMESTAMP '2026-02-20 14:30:00', TIMESTAMP '2026-02-20 14:30:00', 0),
(4, '02', '杭州东', '杭州东', '杭州', '杭州', TIMESTAMP '2026-02-20 20:55:00', TIMESTAMP '2026-02-20 20:55:00', 0),
(5, '01', '北京南', '北京南', '北京', '北京', TIMESTAMP '2026-02-20 07:00:00', TIMESTAMP '2026-02-20 07:00:00', 0),
(5, '02', '济南西', '济南西', '济南', '济南', TIMESTAMP '2026-02-20 08:22:00', TIMESTAMP '2026-02-20 08:20:00', 2),
(5, '03', '南京南', '南京南', '南京', '南京', TIMESTAMP '2026-02-20 09:58:00', TIMESTAMP '2026-02-20 09:56:00', 2),
(5, '04', '上海虹桥', '上海虹桥', '上海', '上海', TIMESTAMP '2026-02-20 11:36:00', TIMESTAMP '2026-02-20 11:36:00', 0),
(6, '01', '北京南', '北京南', '北京', '北京', TIMESTAMP '2026-02-20 09:00:00', TIMESTAMP '2026-02-20 09:00:00', 0),
(6, '02', '上海虹桥', '上海虹桥', '上海', '上海', TIMESTAMP '2026-02-20 13:28:00', TIMESTAMP '2026-02-20 13:28:00', 0),
(7, '01', '北京南', '北京南', '北京', '北京', TIMESTAMP '2026-02-20 10:00:00', TIMESTAMP '2026-02-20 10:00:00', 0),
(7, '02', '上海虹桥', '上海虹桥', '上海', '上海', TIMESTAMP '2026-02-20 14:28:00', TIMESTAMP '2026-02-20 14:28:00', 0);

-- Prices (seat_type: 0=商务座 1=一等座 2=二等座)
INSERT INTO t_train_station_price (train_id, departure, arrival, seat_type, price) VALUES
(1, '北京南', '杭州东', 0, 263050),
(1, '北京南', '杭州东', 1, 90650),
(1, '北京南', '杭州东', 2, 53850),
(2, '北京南', '杭州东', 0, 263050),
(2, '北京南', '杭州东', 1, 90650),
(2, '北京南', '杭州东', 2, 53850),
(3, '北京南', '杭州东', 0, 263050),
(3, '北京南', '杭州东', 1, 90650),
(3, '北京南', '杭州东', 2, 53850),
(4, '北京南', '杭州东', 1, 90650),
(4, '北京南', '杭州东', 2, 53850),
(5, '北京南', '上海虹桥', 0, 174550),
(5, '北京南', '上海虹桥', 1, 93350),
(5, '北京南', '上海虹桥', 2, 55350),
(6, '北京南', '上海虹桥', 0, 174550),
(6, '北京南', '上海虹桥', 1, 93350),
(6, '北京南', '上海虹桥', 2, 55350),
(7, '北京南', '上海虹桥', 0, 174550),
(7, '北京南', '上海虹桥', 1, 93350),
(7, '北京南', '上海虹桥', 2, 55350);

-- Carriages
INSERT INTO t_carriage (train_id, carriage_number, carriage_type, seat_count) VALUES
(1, '01', 0, 28), (1, '02', 1, 56), (1, '03', 1, 56),
(1, '04', 2, 90), (1, '05', 2, 90), (1, '06', 2, 90), (1, '07', 2, 90), (1, '08', 2, 90),
(2, '01', 0, 28), (2, '02', 1, 56), (2, '03', 2, 90), (2, '04', 2, 90),
(3, '01', 0, 28), (3, '02', 1, 56), (3, '03', 2, 90),
(4, '01', 1, 56), (4, '02', 2, 90), (4, '03', 2, 90),
(5, '01', 0, 28), (5, '02', 1, 56), (5, '03', 2, 90), (5, '04', 2, 90),
(6, '01', 0, 28), (6, '02', 1, 56), (6, '03', 2, 90),
(7, '01', 0, 28), (7, '02', 1, 56), (7, '03', 2, 90), (7, '04', 2, 90);
