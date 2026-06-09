Set WshShell = CreateObject("WScript.Shell")
' Запуск сервера в скрытом окне
WshShell.Run chr(34) & "start-server.bat" & chr(34), 0
Set WshShell = Nothing
