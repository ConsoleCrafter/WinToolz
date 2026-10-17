@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title WLAN Passwort Anzeiger ^| Made by ConsoleCrafter ^| WinToolz 0.1

echo ============================================================
echo                    WLAN PASSWORT ANZEIGER
echo ============================================================
echo.
echo Deine WLAN Passwörter sind
echo.

for /f "tokens=2 delims=:" %%A in ('netsh wlan show profiles ^| findstr /C:"alle Benutzer"') do (
    set "PROFIL=%%A"
    set "PROFIL=!PROFIL:~1!"
    set "PW="
    for /f "tokens=2 delims=:" %%B in ('netsh wlan show profile name^="!PROFIL!" key^=clear ^| findstr /C:"Schl"') do (
        set "PW=%%B"
        set "PW=!PW:~1!"
    )
    if defined PW (
        echo WLAN !PROFIL!:
        echo !PW!
        echo.
    )
)

echo.
echo ============================================================
echo [+] Alle WLAN-Passwörter wurden ausgelesen!
echo ============================================================
echo.
pause
endlocal