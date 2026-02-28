@echo off
chcp 65001 >nul
title 12306 V2 - 一键启动

echo ============================================
echo    铁路12306 V2 - 一键启动
echo    无需 Docker / 无需中间件
echo ============================================
echo.

:: Check Java
java -version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 未找到 Java，请安装 JDK 17+
    pause
    exit /b 1
)

:: Check Node
node -v >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 未找到 Node.js，请安装 Node.js 16+
    pause
    exit /b 1
)

echo [1/4] 构建后端...
cd /d "%~dp0backend"
if not exist "target\railway-12306-2.0.0.jar" (
    call mvnw.cmd clean package -DskipTests -q -s .mvn\settings.xml
    if errorlevel 1 (
        echo [ERROR] 后端构建失败
        pause
        exit /b 1
    )
)
echo [OK] 后端构建完成

echo [2/4] 启动后端 (端口 9000)...
start "12306-Backend" cmd /c "java -Dfile.encoding=UTF-8 -jar target\railway-12306-2.0.0.jar"
echo [OK] 后端已启动

:: Wait for backend to be ready
echo [3/4] 等待后端启动...
timeout /t 8 /nobreak >nul

echo [4/4] 启动前端 (端口 8080)...
cd /d "%~dp0frontend"
if not exist "node_modules" (
    echo       安装前端依赖...
    call npm install
)
start "12306-Frontend" cmd /c "npx vite --port 8080"

timeout /t 3 /nobreak >nul

echo.
echo ============================================
echo    启动完成!
echo    前端: http://localhost:8080
echo    后端: http://localhost:9000
echo    H2控制台: http://localhost:9000/h2-console
echo    演示账号: admin / admin123
echo ============================================
echo.

start http://localhost:8080

pause
