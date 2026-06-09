Set WshShell = CreateObject("WScript.Shell")
' Остановка всех node.exe процессов (сервер FreeQwenApi)
' Если используете node для других задач — используйте start-server.bat для остановки
WshShell.Run "cmd /c taskkill /F /IM node.exe /T 2>nul", 0, False
Set WshShell = Nothing
WScript.Echo "Сервер остановлен."
