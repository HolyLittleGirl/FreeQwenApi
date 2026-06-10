@echo off
chcp 65001 >nul

echo ============================================
echo   FreeQwenApi — Status Check
echo ============================================
echo.

REM Проверка по PID
set PID_FILE=%TEMP%\freeqwenapi.pid
if exist "%PID_FILE%" (
    set /p PID=<"%PID_FILE%"
    tasklist /FI "PID eq %PID%" 2>nul | findstr /I "node.exe" >nul
    if %errorlevel% equ 0 (
        echo [OK] Процесс жив (PID: %PID%)
    ) else (
        echo [WARN] PID %PID% не найден (возможно, сервер упал)
        del "%PID_FILE%" 2>nul
    )
) else (
    echo [INFO] PID файл не найден
)

REM Проверка API
echo.
echo Проверка API...
curl -s http://localhost:3264/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] API отвечает: http://localhost:3264/api
    echo.
    
    REM Детали
    for /f "delims=" %%a in ('curl -s http://localhost:3264/api/health') do set HEALTH=%%a
    echo %HEALTH% | findstr "ok" >nul && echo [OK] Статус: работает
    echo.
    call :check_port
) else (
    echo [FAIL] API не отвечает!
    echo.
    echo Возможные причины:
    echo   - Сервер не запущен (используйте run-qwen.bat)
    echo   - Порт 3264 занят другим приложением
)

echo.
pause
exit /b

:check_port
echo Поиск процесса на порту 3264...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":3264 "') do set API_PID=%%a
if defined API_PID (
    tasklist /FI "PID eq %API_PID%" /FO TABLE /NH 2>nul
) else (
    echo [WARN] Процесс на порту 3264 не найден
)
goto :eof
