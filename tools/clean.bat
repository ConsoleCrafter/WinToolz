@echo off
chcp 65001 >nul
title System Cleaner ^| Made by ConsoleCrafter ^| WinToolz 0.1

:: Administrator-Rechte prüfen
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Bitte starte die Datei als Administrator!
    pause
    exit /b
)

echo ============================================================
echo                        SYSTEM CLEANER
echo ============================================================
echo.
echo [1/8] Temp-Dateien und Crash-Dumps aufräumen...
del /q /f /s "%TEMP%\*" >nul 2>&1
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
for /d %%D in ("C:\Windows\Temp\*") do rd /s /q "%%D" >nul 2>&1
del /q /f /s "C:\Windows\MEMORY.DMP" >nul 2>&1
del /q /f /s "C:\Windows\Minidump\*" >nul 2>&1

echo [2/8] Browser-Caches leeren (20 Browser)...
:: Chromium-basierte Browser
del /q /f /s "%LocalAppData%\Google\Chrome\User Data\*\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Microsoft\Edge\User Data\*\Cache\*" >nul 2>&1
del /q /f /s "%AppData%\Opera Software\Opera Stable\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Opera Software\Opera Stable\Cache\*" >nul 2>&1
del /q /f /s "%AppData%\Opera Software\Opera GX Stable\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Opera Software\Opera GX Stable\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\BraveSoftware\Brave-Browser\User Data\*\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Vivaldi\User Data\*\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Arc\User Data\*\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\DuckDuckGo\*\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Yandex\YandexBrowser\User Data\*\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\AVAST Software\Browser\User Data\*\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Maxthon\*\Cache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Comodo\Dragon\User Data\*\Cache\*" >nul 2>&1

:: Gecko- & Firefox-basierte Browser
del /q /f /s "%LocalAppData%\Mozilla\Firefox\Profiles\*\cache2\*" >nul 2>&1
del /q /f /s "%LocalAppData%\LibreWolf\Profiles\*\cache2\*" >nul 2>&1
del /q /f /s "%LocalAppData%\zen\Profiles\*\cache2\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Waterfox\Profiles\*\cache2\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Moonchild Productions\Pale Moon\Profiles\*\cache2\*" >nul 2>&1
del /q /f /s "%LocalAppData%\TorBrowser\Data\Browser\profile.default\cache2\*" >nul 2>&1
del /q /f /s "%LocalAppData%\Mozilla\SeaMonkey\Profiles\*\cache2\*" >nul 2>&1

:: Sonstige / Leichtgewichtige
del /q /f /s "%LocalAppData%\Midori\*\Cache\*" >nul 2>&1

echo [3/8] GPU Shader Caches leeren (NVIDIA / AMD / DirectX)...
del /q /f /s "%LocalAppData%\NVIDIA\DXCache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\NVIDIA\GLCache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\AMD\DxCache\*" >nul 2>&1
del /q /f /s "%LocalAppData%\D3DSCache\*" >nul 2>&1

echo [4/8] Windows Log-Dateien & Fehlerberichte löschen...
del /q /f /s "C:\Windows\Logs\*" >nul 2>&1
del /q /f /s "%ProgramData%\Microsoft\Windows\WER\*" >nul 2>&1

echo [5/8] Papierkorb wird geleert...
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1

echo [6/8] DNS-Cache wird geleert...
ipconfig /flushdns >nul 2>&1

echo [7/8] Windows-Schattenkopien & alte Systemwiederherstellungspunkte löschen...
vssadmin delete shadows /for=C: /oldest >nul 2>&1

echo [8/8] Alte WinSxS/Update-Sicherungen bereinigen (DISM)...
dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase >nul 2>&1

echo.
echo ============================================================
echo [+] Fertig! System und alle Browser-Caches wurden gereinigt.
echo ============================================================
echo.
timeout /t 3 >nul
exit