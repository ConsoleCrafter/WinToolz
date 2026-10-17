@echo off
chcp 65001 >nul
title Sound und Audio Engine Fixer ^| Made by ConsoleCrafter ^| WinToolz 0.1

:: Administrator-Rechte prüfen
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Fordere Administratorrechte an...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ============================================================
echo                 SOUND UND AUDIO ENGINE FIXER
echo ============================================================
echo.

echo [1/3] Stoppe Windows Audio-Dienste...
net stop AudioEndpointBuilder /y >nul 2>&1
net stop Audiosrv /y >nul 2>&1

echo [2/3] Kurze Pause zur Bereinigung der Audio-Puffer...
timeout /t 2 /nobreak >nul

echo [3/3] Starte Windows Audio-Dienste neu...
net start Audiosrv >nul 2>&1
net start AudioEndpointBuilder >nul 2>&1

echo.
echo ============================================================
echo [+] Audio-Engine wurde erfolgreich neu gestartet!
echo [!] Der Sound sollte in wenigen Sekunden wieder da sein.
echo ============================================================
echo.
timeout /t 3 >nul
exit