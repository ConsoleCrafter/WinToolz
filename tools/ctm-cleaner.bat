@echo off
chcp 65001 >nul
title Context Menu Cleaner ^| Made by ConsoleCrafter ^| WinToolz 0.1

:: Admin-Check
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Bitte als Administrator ausfuehren!
    pause
    exit /b
)

echo ============================================================
echo                     CONTEXT MENU CLEANER
echo ============================================================
echo.

echo Entferne nervige Eintraege aus dem Kontextmenue...

:: Clipchamp entfernen
reg delete "HKCR\*\shell\EditWithClipchamp" /f >nul 2>&1

:: Skype Teilen entfernen
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7770E5D0-A2CD-439A-94A2-170B7639520C}" /f >nul 2>&1

:: 3D Print / Edit mit Paint 3D
reg delete "HKCR\SystemFileAssociations\.bmp\Shell\3D Edit" /f >nul 2>&1
reg delete "HKCR\SystemFileAssociations\.png\Shell\3D Edit" /f >nul 2>&1
reg delete "HKCR\SystemFileAssociations\.jpg\Shell\3D Edit" /f >nul 2>&1

echo.
echo ============================================================
echo [+] Müll-Einträge aus dem Kontextmenü entfernt!
echo ============================================================
echo.
timeout /t 3 >nul