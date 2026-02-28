# 12306 铁路购票系统 V2

> 精简单体版 · 零中间件依赖 · 一键启动

## Showcase

### 一句话价值

用最少依赖完成购票系统核心交易闭环，面试现场可快速复现“查票-下单-支付-订单”全链路。

### 1分钟演示视频

- [demo.mp4](docs/showcase/pro_12306购票/demo.mp4)

### 3张关键截图

1. [shot-01.png（车票查询）](docs/showcase/pro_12306购票/shot-01.png)
2. [shot-02.png（下单确认）](docs/showcase/pro_12306购票/shot-02.png)
3. [shot-03.png（订单详情）](docs/showcase/pro_12306购票/shot-03.png)

### 一键运行命令

```powershell
cd pro_12306购票
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -Command '.\startup.bat'
```

### 核心技术决策

1. 用单体架构保证展示稳定性和低运维成本。
2. 用 H2 内嵌数据库降低环境准备门槛，适合招聘方快速验证。
3. 用 JWT 完成前后端分离鉴权，保持接口调用一致性。

### 性能/稳定性证据

- 证据页：[evidence.md](docs/showcase/pro_12306购票/evidence.md)
- 建议展示指标：冷启动时间、查票接口响应、连续下单成功率。

### 面试可提问点

1. 如果要提升并发性能，你会从哪些链路先改？
2. 如何从 H2 迁移到 MySQL 并保证兼容？
3. 如何设计防超卖和幂等下单？

## 与 V1 的区别

| 维度 | V1 | V2 |
|------|----|----|
| 架构 | 6个微服务 + Spring Cloud Gateway | 单体 Spring Boot 3 |
| 数据库 | MySQL + ShardingSphere (16张分表) | H2 内嵌数据库 (零配置) |
| 中间件 | Nacos + RocketMQ + Redis | 无 |
| 前端 | Vue CLI 4 + Ant Design | Vue 3 + Vite (手工设计) |
| 启动 | 需要 Docker + 5个服务 | 双击 startup.bat |

## 一键启动

```bash
# 双击启动
startup.bat
```

或手动启动：

```bash
# 1. 启动后端
cd backend
mvnw.cmd spring-boot:run

# 2. 启动前端 (新终端)
cd frontend
npm install
npm run dev
```

## 访问地址

- 前端: http://localhost:8080
- 后端 API: http://localhost:9000
- H2 数据库控制台: http://localhost:9000/h2-console
  - JDBC URL: `jdbc:h2:file:./data/railway`
  - 用户名: `sa`
  - 密码: (空)

## 演示账号

- 用户名: `admin`
- 密码: `admin123`

## 技术栈

### 后端
- Java 17 + Spring Boot 3.2
- MyBatis-Plus 3.5
- H2 Database (内嵌)
- JWT 认证

### 前端
- Vue 3 + Vite 5
- Vue Router 4
- Axios + Day.js
- 手工 CSS 设计系统 (温暖大地色调)

## 项目结构

```
12306_v2/
├── startup.bat              # 一键启动
├── backend/
│   ├── pom.xml
│   └── src/main/java/com/railway/
│       ├── RailwayApplication.java
│       ├── common/           # JWT, 异常处理, 配置
│       ├── entity/           # 数据实体
│       ├── mapper/           # MyBatis Mapper
│       └── controller/       # REST API
└── frontend/
    ├── index.html
    ├── vite.config.js
    └── src/
        ├── api/              # API 调用
        ├── router/           # 路由配置
        ├── styles/           # 设计系统
        └── views/            # 页面组件
```

## 核心功能

- ✅ 用户注册、登录 (JWT)
- ✅ 车票查询 (支持7条线路)
- ✅ 经停站查询
- ✅ 乘车人管理 (CRUD)
- ✅ 个人信息编辑
- ✅ 订单管理
- ✅ 支付模拟

## 预置数据

- **车站**: 11个热门车站 (北京南、上海虹桥、杭州东等)
- **列车**: 7趟高铁/动车 (京杭线4趟、京沪线3趟)
- **价格**: 商务座、一等座、二等座完整定价

