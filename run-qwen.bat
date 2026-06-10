@echo off
chcp 65001 >nul
title FreeQwenApi Server
color 0A

echo ============================================
echo   FreeQwenApi — Qwen Chat Proxy Server
echo ============================================
echo.

REM Проверяем Node.js
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js не найден. Установите с https://nodejs.org/
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

REM Проверяем не запущен ли уже
set PID_FILE=%TEMP%\freeqwenapi.pid
if exist "%PID_FILE%" (
    set /p OLD_PID=<"%PID_FILE%"
    tasklist /FI "PID eq %OLD_PID%" 2>nul | findstr /I "node.exe" >nul
    if %errorlevel% equ 0 (
        echo [INFO] Сервер уже запущен (PID: %OLD_PID%)
        echo [INFO] API: http://localhost:3264/api
        echo.
        echo Используйте stop-qwen.bat для остановки.
        pause
        exit /b 0
    )
)

echo [INFO] Запуск сервера...
echo [INFO] API: http://localhost:3264/api
echo [INFO] Health: http://localhost:3264/api/health
echo.

REM Запускаем сервер с правильными переменными
set SKIP_ACCOUNT_MENU=true
set NON_INTERACTIVE=true
set QWEN_MAX_SYSTEM_CHARS=180000
set QWEN_TOOL_PROMPT_MODE=minimal
set LOG_LEVEL=info

REM Запускаем в фоне и пишем PID
start /B "" cmd /c "node index.js > logs\server.log 2>&1"

REM Ждем и получаем PID
timeout /t 2 /nobreak >nul
for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq node.exe" /FO LIST ^| findstr /I "PID:"') do (
    set NODE_PID=%%a
    goto :save_pid
)
:save_pid
echo %NODE_PID% > "%PID_FILE%"
echo [OK] Сервер запущен (PID: %NODE_PID%)
echo.
echo Команды:
echo   status-qwen.bat  — проверить состояние
echo   stop-qwen.bat    — остановить сервер
echo   auth-qwen.bat    — управление аккаунтами
echo.
echo Нажми любую клавишу...
pause >nul
