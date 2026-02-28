-- H2 compatible schema
DROP TABLE IF EXISTS t_pay;
DROP TABLE IF EXISTS t_order_item;
DROP TABLE IF EXISTS t_order;
DROP TABLE IF EXISTS t_ticket;
DROP TABLE IF EXISTS t_seat;
DROP TABLE IF EXISTS t_carriage;
DROP TABLE IF EXISTS t_train_station_relation;
DROP TABLE IF EXISTS t_train_station_price;
DROP TABLE IF EXISTS t_train_station;
DROP TABLE IF EXISTS t_train;
DROP TABLE IF EXISTS t_station;
DROP TABLE IF EXISTS t_region;
DROP TABLE IF EXISTS t_passenger;
DROP TABLE IF EXISTS t_user;

CREATE TABLE t_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(256) NOT NULL UNIQUE,
    password VARCHAR(512) NOT NULL,
    real_name VARCHAR(256),
    id_type INT,
    id_card VARCHAR(256),
    phone VARCHAR(128),
    mail VARCHAR(256),
    address VARCHAR(512),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_passenger (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(256) NOT NULL,
    real_name VARCHAR(256),
    id_type INT,
    id_card VARCHAR(256),
    discount_type INT,
    phone VARCHAR(128),
    create_date TIMESTAMP,
    verify_status INT DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_region (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(64),
    full_name VARCHAR(64),
    code VARCHAR(64),
    initial VARCHAR(2),
    spell VARCHAR(64),
    popular_flag INT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_station (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(64),
    name VARCHAR(256),
    spell VARCHAR(64),
    region VARCHAR(64),
    region_name VARCHAR(64),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_train (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    train_number VARCHAR(256),
    train_type INT,
    train_tag VARCHAR(32),
    train_brand VARCHAR(32),
    start_station VARCHAR(256),
    end_station VARCHAR(256),
    start_region VARCHAR(256),
    end_region VARCHAR(256),
    sale_time TIMESTAMP,
    sale_status INT DEFAULT 0,
    departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_train_station (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    train_id BIGINT,
    station_id BIGINT,
    sequence VARCHAR(32),
    departure VARCHAR(64),
    arrival VARCHAR(64),
    start_region VARCHAR(256),
    end_region VARCHAR(256),
    arrival_time TIMESTAMP,
    departure_time TIMESTAMP,
    stopover_time INT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_train_station_price (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    train_id BIGINT,
    departure VARCHAR(64),
    arrival VARCHAR(64),
    seat_type INT,
    price INT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_train_station_relation (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    train_id BIGINT,
    departure VARCHAR(64),
    arrival VARCHAR(64),
    start_region VARCHAR(256),
    end_region VARCHAR(256),
    departure_flag INT,
    arrival_flag INT,
    departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_carriage (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    train_id BIGINT,
    carriage_number VARCHAR(64),
    carriage_type INT,
    seat_count INT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_seat (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    train_id BIGINT,
    carriage_number VARCHAR(64),
    seat_number VARCHAR(64),
    seat_type INT,
    start_station VARCHAR(256),
    end_station VARCHAR(256),
    price INT,
    seat_status INT DEFAULT 0,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_ticket (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(256),
    train_id BIGINT,
    carriage_number VARCHAR(64),
    seat_number VARCHAR(64),
    passenger_id BIGINT,
    ticket_status INT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_sn VARCHAR(64) NOT NULL UNIQUE,
    user_id BIGINT,
    username VARCHAR(256),
    train_id BIGINT,
    train_number VARCHAR(256),
    riding_date DATE,
    departure VARCHAR(64),
    arrival VARCHAR(64),
    departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
    source INT DEFAULT 0,
    status INT DEFAULT 0,
    order_time TIMESTAMP,
    pay_type INT,
    pay_time TIMESTAMP,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_order_item (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_sn VARCHAR(64),
    user_id BIGINT,
    username VARCHAR(256),
    train_id BIGINT,
    carriage_number VARCHAR(64),
    seat_type INT,
    seat_number VARCHAR(64),
    real_name VARCHAR(256),
    id_type INT,
    id_card VARCHAR(256),
    ticket_type INT,
    phone VARCHAR(128),
    status INT DEFAULT 0,
    amount INT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);

CREATE TABLE t_pay (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_sn VARCHAR(64),
    pay_sn VARCHAR(64),
    out_order_sn VARCHAR(128),
    channel INT,
    trade_type INT,
    subject VARCHAR(512),
    order_request_id VARCHAR(64),
    total_amount INT,
    status INT DEFAULT 0,
    pay_time TIMESTAMP,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    del_flag INT DEFAULT 0
);
