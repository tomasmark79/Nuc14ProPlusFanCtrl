@echo off
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    powershell -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

powershell -Command "& { $action = New-ScheduledTaskAction -Execute 'C:\WinUtilities\AsusFanControl\AsusFanControl.exe' -Argument '--set-fan-speeds=36'; $trigger = New-ScheduledTaskTrigger -AtStartup; $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable; $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest; Register-ScheduledTask -TaskName 'AsusFanControl - Set 30pct on startup' -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force; Write-Host 'Uspesne zaregistrovano!' }"

pause
