@echo off
chcp 65001 >nul
title Taskleisten und Icon Fixer ^| Made by ConsoleCrafter ^| WinToolz 0.1

:: Administrator-Rechte prüfen
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Fordere Administratorrechte an...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ============================================================
echo                  TASKLEISTEN UND ICON FIXER
echo ============================================================
echo.

echo [1/4] Beende Windows Explorer Prozess...
taskkill /f /im explorer.exe >nul 2>&1

echo [2/4] Lösche beschädigten IconCache und Thumbnail-Puffer...
cd /d "%LocalAppData%"
del /f /q /a "IconCache.db" >nul 2>&1
del /f /q /a "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
del /f /q /a "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1

echo [3/4] Lösche beschädigte Taskleisten-Icon-Protokolle...
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v "IconStreams" /f >nul 2>&1
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v "PastIconsStream" /f >nul 2>&1

echo [4/4] Starte Windows Explorer und Icon-Engine neu...
start explorer.exe

echo.
echo ============================================================
echo [+] Icon-Cache wurde zurückgesetzt und der Explorer neu gestartet!
echo [!] Alle weißen Striche/Icons sollten jetzt wieder sauber geladen werden.
echo ============================================================
echo.
timeout /t 3 >nul
exit