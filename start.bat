@echo off
setlocal EnableExtensions
chcp 65001 >nul
title WinToolz Launcher ^| Made by ConsoleCrafter ^| WinToolz 0.1

:: ============================================================
::  WINTOOLZ LAUNCHER - Made by ConsoleCrafter
:: ============================================================

:: ESC-Zeichen fuer ANSI-Farben holen
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "CYAN=%ESC%[96m"
set "YELLOW=%ESC%[93m"
set "GREEN=%ESC%[92m"
set "WHITE=%ESC%[97m"
set "GRAY=%ESC%[90m"
set "RED=%ESC%[91m"
set "RST=%ESC%[0m"

:menu
cls
echo.
echo %CYAN%██╗    ██╗██╗███╗   ██╗████████╗ ██████╗  ██████╗ ██╗     ███████╗%RST%
echo %CYAN%██║    ██║██║████╗  ██║╚══██╔══╝██╔═══██╗██╔═══██╗██║     ╚══███╔╝%RST%
echo %CYAN%██║ █╗ ██║██║██╔██╗ ██║   ██║   ██║   ██║██║   ██║██║       ███╔╝ %RST%
echo %CYAN%██║███╗██║██║██║╚██╗██║   ██║   ██║   ██║██║   ██║██║      ███╔╝  %RST%
echo %CYAN%╚███╔███╔╝██║██║ ╚████║   ██║   ╚██████╔╝╚██████╔╝███████╗███████╗%RST%
echo %CYAN% ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚══════╝%RST%
echo.
echo %GRAY%              by ConsoleCrafter   ^|   ver: 0.1   ^|   WinToolz 0.1%RST%
echo.
echo %GRAY%════════════════════════════════════════════════════════════════════════════════════════════════%RST%
echo.
echo       %YELLOW%[ SYSTEM + CLEANUP ]%RST%               %YELLOW%[ REPARATUR ]%RST%                  %YELLOW%[ SETUP + INFO ]%RST%        
echo.
echo   %GREEN%[01]%RST% %WHITE%System Cleaner%RST%             %GREEN%[05]%RST% %WHITE%Icon Fixer%RST%                 %GREEN%[09]%RST% %WHITE%Setup-Assistent%RST%          
echo   %GREEN%[02]%RST% %WHITE%Context Menu Cleaner%RST%       %GREEN%[06]%RST% %WHITE%Sound Fixer%RST%                %GREEN%[10]%RST% %WHITE%WLAN Passwoerter%RST%         
echo   %GREEN%[03]%RST% %WHITE%Bloatware Remover%RST%          %GREEN%[07]%RST% %WHITE%GPU Driver Installer%RST%       %GREEN%[11]%RST% %WHITE%Real Hardware Check%RST%      
echo   %GREEN%[04]%RST% %WHITE%Download Structurator%RST%      %GREEN%[08]%RST% %WHITE%Winget Repair%RST%              %GREEN%[12]%RST% %WHITE%Windows Activator%RST%        
echo.
echo %GRAY%════════════════════════════════════════════════════════════════════════════════════════════════%RST%
echo.
echo   %GRAY%[0] Beenden%RST%   %GRAY%^|   Nummer eingeben und Enter druecken%RST%
echo.
<nul set /p "=%CYAN%TOOL > %RST%"
set /p "choice="

:: Auswahl normalisieren (01 -> 1, 00 -> 0)
set "SEL=%choice%"
if "%SEL%"=="00" set "SEL=0"
if not "%SEL%"=="0" if "%SEL:~0,1%"=="0" set "SEL=%SEL:~1%"

if "%SEL%"=="0" goto :ende
if /i "%choice%"=="q" goto :ende
if "%SEL%"=="1" call :run "System Cleaner" "clean.bat"
if "%SEL%"=="2" call :run "Context Menu Cleaner" "ctm-cleaner.bat"
if "%SEL%"=="3" call :run "Bloatware Remover" "bloatware-remover.bat"
if "%SEL%"=="4" call :run "Download Structurator" "download-structurator.bat"
if "%SEL%"=="5" call :run "Taskleisten und Icon Fixer" "icon-fixer.bat"
if "%SEL%"=="6" call :run "Sound und Audio Engine Fixer" "sound-fix.bat"
if "%SEL%"=="7" call :run "GPU Clean Driver Installer" "makedriver.bat"
if "%SEL%"=="8" call :run "Winget Ultimate Repair und Updater" "sudo-apt-upgrade.bat"
if "%SEL%"=="9" call :run "Setup-Assistent" "installer.bat"
if "%SEL%"=="10" call :run "WLAN Passwort Anzeiger" "WLAN-PW.bat"
if "%SEL%"=="11" call :run "Real Hardware Checker und Benchmark" "real-hardware.bat"
if "%SEL%"=="12" call :run "Windows Activator" "activator.bat"

echo.
echo   %RED%Ungueltige Eingabe! Bitte eine Nummer von 0 bis 12 eingeben.%RST%
timeout /t 2 >nul
goto :menu

:: ============================================================
::  TOOL STARTEN
:: ============================================================
:run
cls
echo.
echo   %CYAN%Starte %~1 ...%RST%
echo.
call "%~dp0tools\%~2"
echo.
echo   %GRAY%Drucke eine beliebige Taste, um zum Menue zurueckzukehren...%RST%
pause >nul
exit /b

:ende
cls
echo.
echo   %GREEN%Danke, dass du WinToolz benutzt!%RST%
echo.
echo   %GRAY%Made by ConsoleCrafter  ^|  WinToolz 0.1%RST%
echo.
timeout /t 2 >nul
endlocal
exit /b
