@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Winget Ultimate Repair und Updater ^| Made by ConsoleCrafter ^| WinToolz 0.1

:: ============================================================
:: 0. ADMIN-PRUEFUNG (PFLICHT)
:: ============================================================
net session >nul 2>&1
if not %errorlevel%==0 (
    echo Fordere Administratorrechte an...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Umgebungspfade erweitern
set "PATH=%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps;%ProgramFiles%\WindowsApps;C:\Program Files\WindowsApps"

cls
echo ============================================================
echo              WINGET ULTIMATE REPAIR UND UPDATER
echo ============================================================
echo.

:: Prüfen ob Winget nicht doch schon geht
call :check_winget
if !WINGET_OK!==1 goto run_update

echo [!] Winget fehlt oder ist defekt. Starte Reparatur-Prozedur...
echo.

:: ============================================================
:: METHODE 1: Standardsuche im AppData PATH auffrischen
:: ============================================================
echo [Methode 01/20] Prüfe versteckte AppData-Binaries...
set "PATH=%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps;%ProgramFiles%\WindowsApps"
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 2: Windows Package Manager via PowerShell Register
:: ============================================================
echo [Methode 02/20] Registriere AppX-Pakete fuer aktuellen User neu...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.DesktopAppInstaller* | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\"}" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 3: AppX-Registrierung fuer ALL USERS
:: ============================================================
echo [Methode 03/20] Registriere AppX-Pakete fuer ALLE User neu...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers *Microsoft.DesktopAppInstaller* | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\"}" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 4: MS Store AppX Manifest Reset
:: ============================================================
echo [Methode 04/20] Erzwinge Re-Indexierung des Store Package Catalogs...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers *WindowsStore* | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\"}" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 5: App Installer über Add-AppxPackage mit Direct-URL
:: ============================================================
echo [Methode 05/20] Lade und installiere Bundle direkt von Microsoft (aka.ms)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Add-AppxPackage -Path 'https://aka.ms/getwinget'" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 6: AppInstaller MSIXBundle Download ^& Offline Install (Orig 2022-Way)
:: ============================================================
echo [Methode 06/20] Offline-Download ^& Force-Install des AppInstallers...
set "MSIX=%TEMP%\winget.msixbundle"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile '%MSIX%' -UseBasicParsing" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-AppxPackage -Path '%MSIX%' -ErrorAction SilentlyContinue" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 7: Microsoft VCLibs / UI.Xaml Dependencies laden
:: ============================================================
echo [Methode 07/20] Lade Dependencies (VCLibs, UI.Xaml) herunter und verknüpfe...
set "DEPZIP=%TEMP%\wg_deps.zip"
set "DEPDIR=%TEMP%\wg_deps"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/DesktopAppInstaller_Dependencies.zip' -OutFile '%DEPZIP%' -UseBasicParsing; Expand-Archive -Path '%DEPZIP%' -DestinationPath '%DEPDIR%' -Force" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$dep=@(Get-ChildItem -Path '%DEPDIR%' -Recurse -Filter *.appx -ErrorAction SilentlyContinue | Where-Object { $_.FullName -match 'x64' } | ForEach-Object { $_.FullName }); if ($dep.Count -gt 0) { Add-AppxPackage -Path '%MSIX%' -DependencyPath $dep -ErrorAction SilentlyContinue } else { Add-AppxPackage -Path '%MSIX%' -ErrorAction SilentlyContinue }" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 8: PowerShell PSGallery Module (Microsoft.WinGet.Client)
:: ============================================================
echo [Methode 08/20] Installiere Microsoft.WinGet.Client via PSGallery...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Install-PackageProvider -Name NuGet -Force | Out-Null; Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery -Scope AllUsers -AllowClobber" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 9: Microsoft.WinGet.Client Repair-Cmdlet
:: ============================================================
echo [Methode 09/20] Führe PowerShell Repair-WinGetPackageManager aus...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Import-Module Microsoft.WinGet.Client -ErrorAction SilentlyContinue; Repair-WinGetPackageManager -AllUsers -Force -Latest" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 10: AppX Deployment Service (AppXSVC) Neustart
:: ============================================================
echo [Methode 10/20] Starte Windows AppX Deployment Service neu...
net stop AppXSVC >nul 2>&1
net start AppXSVC >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 11: Developer Mode Registry Tweak aktivieren
:: ============================================================
echo [Methode 11/20] Aktiviere Sideloading / Developer Mode in Registry...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowAllTrustedApps /t REG_DWORD /d 1 /f >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-AppxPackage -Path '%MSIX%' -ForceUpdateFromAnyVersion -ErrorAction SilentlyContinue" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 12: GitHub REST API - Neuestes Release direkt greifen
:: ============================================================
echo [Methode 12/20] Ziehe neueste GitHub-Release Assets via REST API...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $val = (Invoke-RestMethod -Uri 'https://api.github.com/repos/microsoft/winget-cli/releases/latest').assets | Where-Object {$_.name -like '*.msixbundle'} | Select-Object -First 1 -ExpandProperty browser_download_url; Invoke-WebRequest -Uri $val -OutFile '$env:TEMP\latest_winget.msixbundle'; Add-AppxPackage -Path '$env:TEMP\latest_winget.msixbundle' -ErrorAction SilentlyContinue" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 13: Windows Store App License Reset via DISM
:: ============================================================
echo [Methode 13/20] Repariere Provisioned AppX Packages via DISM...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like '*DesktopAppInstaller*'} | Remove-AppxProvisionedPackage -Online" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-AppxProvisionedPackage -Online -PackagePath '%MSIX%' -SkipLicense" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 14: WSReset (Windows Store Cache leeren)
:: ============================================================
echo [Methode 14/20] Leere Windows Store Cache (WSReset)...
wsreset.exe /silent >nul 2>&1
timeout /t 3 /nobreak >nul
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 15: ExecutionAlias Registry Repair
:: ============================================================
echo [Methode 15/20] Repariere ExecutionAliases in der Registry...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\App Paths\winget.exe" /ve /t REG_SZ /d "%LOCALAPPDATA%\Microsoft\WindowsApps\winget.exe" /f >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage *DesktopAppInstaller* | Reset-AppxPackage" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 16: Systemweite PATH-Erzwingung via Setx
:: ============================================================
echo [Methode 16/20] Setze finale System-Umgebungsvariablen fest...
setx PATH "%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps;C:\Program Files\WindowsApps" /M >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 17: AppX Package DB State Fix (Reset AppData Temp)
:: ============================================================
echo [Methode 17/20] Bereinige beschädigten AppX-Temp-Cache...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item -Path '$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-AppxPackage -Register 'C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*x64__8wekyb3d8bbwe\AppXManifest.xml' -DisableDevelopmentMode" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 18: Suche direkte EXE-Pfade in Program Files
:: ============================================================
echo [Methode 18/20] Suche direkte EXE-Pfade in Program Files...
for /f "delims=" %%a in ('dir /b /s "C:\Program Files\WindowsApps\winget.exe" 2^>nul') do (
    set "WINGET_EXPLICIT=%%a"
)
if defined WINGET_EXPLICIT (
    set "PATH=%PATH%;!WINGET_EXPLICIT:\winget.exe=!"
)
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 19: Standalone Winget Portable Binary Extraktion
:: ============================================================
echo [Methode 19/20] Extrahiere Winget-StandAlone Binary aus MSIX...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Expand-Archive -Path '%MSIX%' -DestinationPath '$env:TEMP\winget_extracted' -Force; $innerMsix = Get-ChildItem -Path '$env:TEMP\winget_extracted' -Filter '*x64.msix' | Select-Object -ExpandProperty FullName; Expand-Archive -Path $innerMsix -DestinationPath '$env:TEMP\winget_bin' -Force; Copy-Item '$env:TEMP\winget_bin\winget.exe' '$env:SystemRoot\System32\winget.exe' -Force" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: ============================================================
:: METHODE 20: NUKLEARE METHODE (Kopiere AppX-Binary nach System32)
:: ============================================================
echo [Methode 20/20] NUKLEARE METHODE: Kopiere AppX-Binary direkt nach System32...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\Program Files\WindowsApps' -Filter 'Microsoft.DesktopAppInstaller_*x64__8wekyb3d8bbwe' | ForEach-Object { Copy-Item -Path \"$($_.FullName)\*\" -Destination '$env:SystemRoot\System32' -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1
call :check_winget
if !WINGET_OK!==1 goto success

:: Fallback Check
echo.
echo ============================================================
echo [FEHLER] Alle 20 Methoden sind fehlgeschlagen. 
echo Dein Windows Store/AppX-System hat tiefere Beschädigungen.
echo Empfehlung: Führe 'sfc /scannow' oder 'DISM /Online /Cleanup-Image /RestoreHealth' aus.
echo ============================================================
echo.
pause
exit /b 1

:check_winget
set "WINGET_OK=0"
set "PATH=%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps;%ProgramFiles%\WindowsApps;C:\Program Files\WindowsApps"
winget --version >nul 2>&1
if not errorlevel 1 set "WINGET_OK=1"
exit /b

:success
echo.
echo ============================================================
echo [ERFOLG] Winget wurde erfolgreich einsatzbereit gemacht!
echo Version:
winget --version
echo ============================================================
echo.

:run_update
echo [UPGRADE] Starte Update für ALLE installierten Programme...
echo.
winget upgrade --all --accept-package-agreements --accept-source-agreements

echo.
echo ============================================================
echo                        FERTIG!
echo ============================================================
echo.
pause
exit /b