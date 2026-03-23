
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

"%~dp0PsExec" -i -s -d "%~dp0AsusFanControlGUI.exe"


@REM Read [](file:///c%3A/WinUtilities/AsusFanControl/run.bat)

@REM Bat soubor tu je ze dvou důvodů:

@REM **1. Eskalace oprávnění (Administrator)**
@REM Řádky 1–5 kontrolují, zda skript běží jako správce (`net session`). Pokud ne, sám sebe restartuje přes PowerShell s `RunAs` — tedy vyžádá si UAC prompt.

@REM **2. Spuštění pod systémovým účtem SYSTEM (`-s` flag v PsExec)**
@REM ```bat
@REM "%~dp0PsExec" -i -s -d "%~dp0AsusFanControlGUI.exe"
@REM ```
@REM - `PsExec` je nástroj od Sysinternals
@REM - `-s` = spustí AsusFanControlGUI.exe pod účtem **NT AUTHORITY\SYSTEM**
@REM - `-i` = interaktivně (zobrazí GUI na ploše)
@REM - `-d` = nečeká na ukončení procesu

@REM **Proč ovládání větráků funguje jen přes tento soubor:**
@REM AsusFanControlGUI.exe potřebuje přístup k hardwarovým registrům nebo WMI/ACPI rozhraní ASUS (pro čtení/zápis rychlosti větráků), ke kterým má přístup **pouze účet SYSTEM**. Ani Administrator nestačí — proto PsExec s `-s`.

@REM Bez tohoto batu by aplikace buď:
@REM - vůbec nešla spustit (chyba oprávnění), nebo
@REM - šla spustit, ale nemohla zapisovat do hardware registrů → větráky by nereagovaly