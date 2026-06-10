@echo off
chcp 65001 >nul
title FreeQwenApi — Install & Setup

echo ============================================
echo   FreeQwenApi — Быстрая установка
echo ============================================
echo.

REM Проверка Node.js
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js не найден!
    echo Установите с https://nodejs.org/ (LTS версия)
    pause
    exit /b 1
)

echo [OK] Node.js найден
node --version

REM Клонирование
if not exist "FreeQwenApi" (
    echo.
    echo [INFO] Клонирую репозиторий...
    git clone https://github.com/ForgetMeAI/FreeQwenApi.git
    if %errorlevel% neq 0 (
        echo [ERROR] Не удалось клонировать
        pause
        exit /b 1
    )
)

cd FreeQwenApi

REM Установка зависимостей
echo.
echo [INFO] Установка зависимостей...
call npm install

if %errorlevel% neq 0 (
    echo [ERROR] Не удалось установить зависимости
    pause
    exit /b 1
)

echo [OK] Зависимости установлены

REM Авторизация
echo.
echo [INFO] Сейчас откроется браузер для входа в Qwen Chat.
echo [INFO] Войдите в аккаунт и вернитесь в это окно.
echo.
pause
call npm run auth

echo.
echo ============================================
echo   Установка завершена!
echo ============================================
echo.
echo Для запуска: run-qwen.bat
echo Для проверки: status-qwen.bat
echo Для остановки: stop-qwen.bat
echo Для аккаунтов: auth-qwen.bat
echo.
pause
