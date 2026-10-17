@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title GPU Clean Driver Installer ^| Made by ConsoleCrafter ^| WinToolz 0.1

:: ============================================================
:: 0. ADMIN-PRUEFUNG
:: ============================================================
net session >nul 2>&1
if not %errorlevel%==0 (
    echo Fordere Administratorrechte an...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

cls
echo ============================================================
echo                  GPU CLEAN DRIVER INSTALLER
echo ============================================================
echo.

echo [1/5] Scanne System nach Grafikkarten...
echo.

:: Sauberer GPU Scan via PowerShell (vermeidet leere WMIC-Zeilen)
set "GPU_TARGET="
for /f "delims=" %%g in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name"') do (
    echo Gefundene GPU: %%g
    echo %%g | findstr /i /v "Radeon(TM) Graphics Intel(R) HD Graphics UHD Graphics" >nul
    if not errorlevel 1 (
        set "GPU_TARGET=%%g"
    )
)

:: Fallback, falls nur eine iGPU verbaut ist
if not defined GPU_TARGET (
    for /f "delims=" %%g in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name | Select-Object -First 1"') do (
        set "GPU_TARGET=%%g"
    )
)

if not defined GPU_TARGET (
    echo.
    echo [FEHLER] Keine Grafikkarte im System erkannt!
    pause
    exit /b 1
)

echo.
echo [SELEKTION] Ziel-Grafikkarte fuer Treiber-Update:
echo -^> !GPU_TARGET!
echo.

echo !GPU_TARGET! | findstr /i "NVIDIA" >nul
if not errorlevel 1 goto nvidia_path

echo !GPU_TARGET! | findstr /i "AMD" >nul
if not errorlevel 1 goto amd_path

echo !GPU_TARGET! | findstr /i "Intel" >nul
if not errorlevel 1 goto intel_path

echo [FEHLER] Unbekannter GPU-Hersteller bei: !GPU_TARGET!
pause
exit /b 1

:: ============================================================
:: 2. NVIDIA STRANG (NO BLOATWARE)
:: ============================================================
:nvidia_path
echo [2/5] NVIDIA Hardware bestätigt (RTX/GTX). Erstelle Arbeitsverzeichnis...
set "WORK_DIR=%TEMP%\nvidia_clean_driver"
if exist "%WORK_DIR%" rd /s /q "%WORK_DIR%"
mkdir "%WORK_DIR%"

echo [3/5] Lade NVIDIA DCH Treiber-Paket herunter...
set "NV_URL=https://us.download.nvidia.com/Windows/551.86/551.86-desktop-win10-win11-64bit-international-dch-whql.exe"

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%NV_URL%' -OutFile '%WORK_DIR%\nv_setup.exe' -UseBasicParsing"

if not exist "%WORK_DIR%\nv_setup.exe" (
    echo [FEHLER] Download fehlgeschlagen!
    pause
    exit /b 1
)

echo [4/5] Extrahiere Paket und eliminiere Bloatware (GFExperience, Telemetrie, App)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%WORK_DIR%\nv_setup.exe' -DestinationPath '%WORK_DIR%\extracted' -Force" >nul 2>&1

:: MÜLL-ORDNER PURGE
rd /s /q "%WORK_DIR%\extracted\NVApp" >nul 2>&1
rd /s /q "%WORK_DIR%\extracted\GFExperience" >nul 2>&1
rd /s /q "%WORK_DIR%\extracted\GFExperienceService" >nul 2>&1
rd /s /q "%WORK_DIR%\extracted\NVTelemetry" >nul 2>&1
rd /s /q "%WORK_DIR%\extracted\NVIDIA.Update" >nul 2>&1
rd /s /q "%WORK_DIR%\extracted\Display.Update" >nul 2>&1
rd /s /q "%WORK_DIR%\extracted\ShieldWirelessController" >nul 2>&1

echo [5/5] Installiere NACKTEN NVIDIA Display- ^& Audio-Treiber...
"%WORK_DIR%\extracted\setup.exe" -s -n

goto success

:: ============================================================
:: 3. AMD STRANG (DRIVER ONLY)
:: ============================================================
:amd_path
echo [2/5] AMD Hardware bestätigt. Erstelle Arbeitsverzeichnis...
set "WORK_DIR=%TEMP%\amd_clean_driver"
if exist "%WORK_DIR%" rd /s /q "%WORK_DIR%"
mkdir "%WORK_DIR%"

echo [3/5] Lade AMD Treiber herunter...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://drivers.amd.com/drivers/installer/24.10/beta/radeon-software-adrenalin-edition-auto-detect-install.exe' -OutFile '%WORK_DIR%\amd_setup.exe' -UserAgent 'Mozilla/5.0'" >nul 2>&1

echo [4/5] Installiere reines AMD Treiber-Paket (Minimal Driver)...
"%WORK_DIR%\amd_setup.exe" /S /DRIVERONLY /NORESTART
goto success

:: ============================================================
:: 4. INTEL STRANG (MINIMAL INSTALL)
:: ============================================================
:intel_path
echo [2/5] Intel Graphics erkannt...
set "WORK_DIR=%TEMP%\intel_clean_driver"
if exist "%WORK_DIR%" rd /s /q "%WORK_DIR%"
mkdir "%WORK_DIR%"

echo [3/5] Installiere Intel Grafikkartentreiber ohne Arc Control...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://dsmain.intel.com/driver-action' -OutFile '%WORK_DIR%\intel_setup.exe'" >nul 2>&1
"%WORK_DIR%\intel_setup.exe" -s -noarc
goto success

:success
if exist "%WORK_DIR%" rd /s /q "%WORK_DIR%" >nul 2>&1
echo.
echo ============================================================
echo [ERFOLG] Reiner Grafiktreiber ohne Bloatware installiert!
echo ============================================================
echo.
pause
exit /b