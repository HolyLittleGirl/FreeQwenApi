@echo off
chcp 65001 >nul 2>&1
title FreeQwenApi Server
color 0A

echo.
echo ============================================
echo   FreeQwenApi — Qwen Chat Proxy Server
echo ============================================
echo.

REM Проверяем npm
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] npm не найден. Установите Node.js.
    echo.
    pause
    exit /b 1
)

REM Проверяем зависимости
if not exist "node_modules" (
    echo [INFO] Установка зависимостей...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] Не удалось установить зависимости.
        pause
        exit /b 1
    )
    echo.
)

REM Проверяем аккаунты
if not exist "session\tokens.json" (
    echo [WARN] Нет авторизованных аккаунтов.
    echo [INFO] Запускаю мастер авторизации...
    echo.
    call npm run auth
    if %errorlevel% neq 0 (
        echo [ERROR] Авторизация не выполнена.
        pause
        exit /b 1
    )
    echo.
)

REM Проверяем порт
netstat -ano | findstr ":3264 " >nul 2>&1
if %errorlevel% equ 0 (
    echo [WARN] Порт 3264 уже занят.
    echo [INFO] Остановите другой процесс или измените порт.
    echo.
    pause
    exit /b 1
)

echo [INFO] Запуск сервера...
echo [INFO] API: http://localhost:3264/api
echo [INFO] Health: http://localhost:3264/api/health
echo.
echo Нажмите Ctrl+C для остановки.
echo ============================================
echo.

REM Запускаем сервер
call npm start

echo.
echo Сервер остановлен.
pause
