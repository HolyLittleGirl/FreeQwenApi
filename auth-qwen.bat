@echo off
chcp 65001 >nul
title FreeQwenApi — Account Manager

echo ============================================
echo   FreeQwenApi — Управление аккаунтами
echo ============================================
echo.
echo 1. Добавить аккаунт
echo 2. Список аккаунтов
echo 3. Перелогинить аккаунт
echo 4. Удалить аккаунт
echo 5. Синхронизировать модели
echo 6. Тест API (smoke test)
echo 0. Выход
echo.

set /p CHOICE="Выберите действие: "

if "%CHOICE%"=="1" call npm run auth -- --add
if "%CHOICE%"=="2" call npm run auth -- --list
if "%CHOICE%"=="3" call npm run auth -- --relogin
if "%CHOICE%"=="4" call npm run auth -- --remove
if "%CHOICE%"=="5" call npm run models:sync
if "%CHOICE%"=="6" call npm run smoke
if "%CHOICE%"=="0" exit /b

echo.
pause
