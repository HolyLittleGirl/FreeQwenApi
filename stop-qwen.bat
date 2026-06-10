@echo off
chcp 65001 >nul
title FreeQwenApi — Stop Server

set PID_FILE=%TEMP%\freeqwenapi.pid

if not exist "%PID_FILE%" (
    echo [WARN] Нет сохраненного PID. Ищу node.exe на порту 3264...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":3264 "') do (
        set PID=%%a
        goto :found
    )
    echo [INFO] Процесс не найден на порту 3264.
    goto :cleanup
)

:found
set /p PID=<"%PID_FILE%"
echo [INFO] Останавливаю FreeQwenApi (PID: %PID%)...
taskkill /F /PID %PID% >nul 2>&1

if %errorlevel% equ 0 (
    echo [OK] Сервер остановлен.
) else (
    echo [WARN] Не удалось остановить PID %PID%.
    echo [INFO] Пробую найти по порту...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":3264 "') do (
        taskkill /F /PID %%a >nul 2>&1
        echo [OK] Процесс %%a остановлен.
    )
)

:cleanup
if exist "%PID_FILE%" del "%PID_FILE%"
echo.
pause
