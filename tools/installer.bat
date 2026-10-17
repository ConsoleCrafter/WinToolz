@echo off
setlocal
chcp 65001 >nul
title Setup-Assistent ^| Made by ConsoleCrafter ^| WinToolz 0.1

:: ============================================================
::  SETUP-ASSISTENT - ALL IN ONE
:: ============================================================

:: Admin-Check (startet sich selbst als Administrator neu)
net session >nul 2>&1
if not %errorlevel%==0 (
    echo Fordere Administratorrechte an...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Defaults (verhindert Crash bei uebersprungenen Pfaden)
set "PC_TYPE="
set "THEME="
set "POWER="
set "PROGS="
set "LIST="
set "DO_INSTALL=0"
set "DO_UPGRADE=0"

:: Programmkatalog laden (P1..Pn = winget-IDs)
call :load_catalog

cls
echo ============================================================
echo                       SETUP-ASSISTENT
echo ============================================================
echo.

:: ---------- FRAGE 1 ----------
:ask_pc
set "pc="
echo ------------------------------------------------------------
echo  Frage 1: Wie ist dein neuer PC?
echo ------------------------------------------------------------
echo   [1] Laggy    (schwach - Optik aus, Performance an)
echo   [2] Highend  (stark - Optik an, Effekte an)
echo.
set /p pc="Auswahl (1/2): "
if "%pc%"=="1" set "PC_TYPE=laggy"
if "%pc%"=="2" set "PC_TYPE=highend"
if not defined PC_TYPE (
    echo   Ungueltige Eingabe.
    echo.
    goto ask_pc
)

:: ---------- FRAGE 2 ----------
:ask_theme
set "theme="
echo.
echo ------------------------------------------------------------
echo  Frage 2: Dark oder Light Mode?
echo ------------------------------------------------------------
echo   [1] Dark
echo   [2] Light
echo   [3] Windows-Standard lassen
echo.
set /p theme="Auswahl (1/2/3): "
if "%theme%"=="1" set "THEME=dark"
if "%theme%"=="2" set "THEME=light"
if "%theme%"=="3" set "THEME=default"
if not defined THEME (
    echo   Ungueltige Eingabe.
    goto ask_theme
)

:: ---------- FRAGE 3 ----------
:ask_power
set "power="
echo.
echo ------------------------------------------------------------
echo  Frage 3: Energieplan?
echo ------------------------------------------------------------
echo   [1] Hoechstleistung
echo   [2] Ausbalanciert
echo   [3] Energiesparen
echo.
set /p power="Auswahl (1/2/3): "
if "%power%"=="1" set "POWER=high"
if "%power%"=="2" set "POWER=balanced"
if "%power%"=="3" set "POWER=saver"
if not defined POWER (
    echo   Ungueltige Eingabe.
    goto ask_power
)

:: ---------- FRAGE 4 ----------
:ask_install
set "doinstall="
echo.
echo ------------------------------------------------------------
echo  Frage 4: Moechtest du Programme installieren? (y/n)
echo ------------------------------------------------------------
set /p doinstall="Auswahl (y/n): "
if /i "%doinstall%"=="y" (set "DO_INSTALL=1" & goto ask_progs)
if /i "%doinstall%"=="n" (set "DO_INSTALL=0" & goto ask_upgrade)
echo   Ungueltige Eingabe.
goto ask_install

:: ---------- PROGRAMM-AUSWAHL ----------
:ask_progs
set "progs="
set "PROGS="
mode con cols=130 lines=60 >nul 2>&1
cls
echo ==================================================================================================================
echo                                              PROGRAMM-AUSWAHL
echo ==================================================================================================================
echo  Nummern mit Komma trennen, z.B. 2,17,42,86    ALL = alles (ohne LOOK 86-92)    NONE = nichts
echo ------------------------------------------------------------------------------------------------------------------
echo  [BROWSER]     1 Firefox  2 Chrome  3 Brave  4 Opera  5 Opera GX  6 Vivaldi  7 LibreWolf  8 Tor Browser
echo  [MESSAGING]   9 Discord  10 Zoom  11 Teams  12 Thunderbird  13 Telegram  14 Signal  15 Slack  16 Pidgin
echo  [MEDIA]      17 VLC  18 Spotify  19 iTunes  20 AIMP  21 foobar2000  22 Winamp  23 MusicBee  24 K-Lite Codecs
echo               25 MPC-HC  26 Audacity  27 HandBrake  28 OBS  29 MKVToolNix  30 Kodi
echo  [IMAGING]    31 IrfanView  32 XnView MP  33 ImageGlass  34 FastStone  35 GIMP  36 Paint.NET  37 Krita
echo               38 Inkscape  39 Blender  40 ShareX  41 Greenshot  42 Lightshot
echo  [DOKUMENTE]  43 LibreOffice  44 OpenOffice  45 OnlyOffice  46 SumatraPDF  47 Foxit  48 Acrobat Reader
echo               49 Obsidian  50 Calibre
echo  [CLOUD]      51 Dropbox  52 Google Drive  53 Nextcloud  54 MEGA
echo  [SECURITY]   55 Malwarebytes  56 Avast  57 KeePass  58 KeePassXC  59 Bitwarden  60 Proton VPN
echo  [UTILS]      61 7-Zip  62 PeaZip  63 WinRAR  64 Everything  65 PowerToys  66 Revo  67 BCUninstaller
echo               68 WizTree  69 WinDirStat  70 TreeSize  71 CCleaner  72 Recuva  73 Speccy  74 CPU-Z
echo               75 HWiNFO  76 Afterburner  77 DDU  78 Rufus  79 Etcher  80 Ventoy  81 ImgBurn
echo               82 AutoHotkey  83 Process Explorer  84 AnyDesk  85 TeamViewer
echo  [LOOK]       86 RetroBar (Win95/XP-Taskleiste)  87 ExplorerPatcher (Win10-Taskleiste/Startmenue fuer Win11)
echo               88 StartAllBack  89 Open-Shell  90 TranslucentTB  91 Rainmeter  92 Windhawk
echo  [DEV]        93 VSCode  94 Cursor  95 IntelliJ  96 Git  97 GitHub Desktop  98 Python  99 Node.js
echo               100 JDK 21  101 PowerShell7  102 Windows Terminal  103 Notepad++  104 WinMerge  105 PuTTY
echo               106 WinSCP  107 FileZilla  108 Postman
echo  [RUNTIMES]   109 .NET 8  110 VC++ x64  111 VC++ x86  112 DirectX
echo  [GAMING]     113 Steam  114 Epic  115 GOG  116 Ubisoft  117 EA App  118 Battle.net  119 Prism  120 MC Launcher  121 qBittorrent
echo.
set /p progs="Auswahl: "
if "%progs%"=="" goto ask_progs
set "PROGS=%progs%"
set "PROGS=%PROGS: =%"
if "%PROGS%"=="" goto ask_progs
if /i "%PROGS%"=="ALL" goto ask_upgrade
if /i "%PROGS%"=="NONE" goto ask_upgrade
echo(%PROGS%| findstr /r /x "[0-9][0-9,]*" >nul
if errorlevel 1 (
    echo   Ungueltige Eingabe - nur Zahlen mit Komma, ALL oder NONE.
    timeout /t 2 >nul
    goto ask_progs
)

:: ---------- FRAGE 5 ----------
:ask_upgrade
set "doupg="
echo.
echo ------------------------------------------------------------
echo  Frage 5: Alle installierten Programme updaten? (y/n)
echo ------------------------------------------------------------
set /p doupg="Auswahl (y/n): "
if /i "%doupg%"=="y" (set "DO_UPGRADE=1" & goto summary)
if /i "%doupg%"=="n" (set "DO_UPGRADE=0" & goto summary)
echo   Ungueltige Eingabe.
goto ask_upgrade

:: ============================================================
::  UEBERSICHT
:: ============================================================
:summary
cls
echo ============================================================
echo                    WIRD AUSGEFUEHRT...
echo ============================================================
echo.
echo  PC-Typ        : %PC_TYPE%
echo  Theme         : %THEME%
echo  Energieplan   : %POWER%
echo  Installation  : %DO_INSTALL%
echo  Programme     : %PROGS%
echo  Winget Update : %DO_UPGRADE%
echo.
echo  Starte in 3 Sekunden...
timeout /t 3 /nobreak >nul

:: ============================================================
::  AUSFUEHRUNG
:: ============================================================
:: DNS zuerst, damit Downloads (winget etc.) schon davon profitieren
call :set_dns

:: ---------- WINGET SICHERSTELLEN (nur wenn gebraucht) ----------
if "%DO_INSTALL%"=="0" if "%DO_UPGRADE%"=="0" goto skip_winget
call :ensure_winget
:skip_winget

call :auto_setup
if "%PC_TYPE%"=="laggy"   call :tweak_laggy
if "%PC_TYPE%"=="highend" call :tweak_highend
if "%THEME%"=="dark"      call :set_dark
if "%THEME%"=="light"     call :set_light
if "%POWER%"=="high"      call :power_high
if "%POWER%"=="balanced"  call :power_balanced
if "%POWER%"=="saver"     call :power_saver
call :restart_explorer
if "%DO_INSTALL%"=="1"    call :install_progs
if "%DO_UPGRADE%"=="1"    call :upgrade_all

echo.
echo ============================================================
echo                       FERTIG!
echo ============================================================
echo.
set "rb="
set /p rb="Jetzt neu starten? (y/n): "
if /i "%rb%"=="y" (
    shutdown /r /t 10 /c "Neustart in 10 Sekunden..."
) else (
    pause
)
exit /b


:: ============================================================
::  UNTERFUNKTIONEN
:: ============================================================

:load_catalog
set "MAXP=121"
:: BROWSER
set "P1=Mozilla.Firefox"
set "P2=Google.Chrome"
set "P3=Brave.Brave"
set "P4=Opera.Opera"
set "P5=Opera.OperaGX"
set "P6=Vivaldi.Vivaldi"
set "P7=LibreWolf.LibreWolf"
set "P8=TorProject.TorBrowser"
:: MESSAGING
set "P9=Discord.Discord"
set "P10=Zoom.Zoom"
set "P11=Microsoft.Teams"
set "P12=Mozilla.Thunderbird"
set "P13=Telegram.TelegramDesktop"
set "P14=OpenWhisperSystems.Signal"
set "P15=SlackTechnologies.Slack"
set "P16=Pidgin.Pidgin"
:: MEDIA
set "P17=VideoLAN.VLC"
set "P18=Spotify.Spotify"
set "P19=Apple.iTunes"
set "P20=AIMP.AIMP"
set "P21=PeterPawlowski.foobar2000"
set "P22=Winamp.Winamp"
set "P23=MusicBee.MusicBee"
set "P24=CodecGuide.K-LiteCodecPack.Standard"
set "P25=clsid2.mpc-hc"
set "P26=Audacity.Audacity"
set "P27=HandBrake.HandBrake"
set "P28=OBSProject.OBSStudio"
set "P29=MoritzBunkus.MKVToolNix"
set "P30=XBMCFoundation.Kodi"
:: IMAGING
set "P31=IrfanSkiljan.IrfanView"
set "P32=XnSoft.XnViewMP"
set "P33=DuongDieuPhap.ImageGlass"
set "P34=FastStone.Viewer"
set "P35=GIMP.GIMP"
set "P36=dotPDN.PaintDotNet"
set "P37=KDE.Krita"
set "P38=Inkscape.Inkscape"
set "P39=BlenderFoundation.Blender"
set "P40=ShareX.ShareX"
set "P41=Greenshot.Greenshot"
set "P42=Skillbrains.Lightshot"
:: DOKUMENTE
set "P43=TheDocumentFoundation.LibreOffice"
set "P44=Apache.OpenOffice"
set "P45=ONLYOFFICE.DesktopEditors"
set "P46=SumatraPDF.SumatraPDF"
set "P47=Foxit.FoxitReader"
set "P48=Adobe.Acrobat.Reader.64-bit"
set "P49=Obsidian.Obsidian"
set "P50=calibre.calibre"
:: CLOUD
set "P51=Dropbox.Dropbox"
set "P52=Google.GoogleDrive"
set "P53=Nextcloud.NextcloudDesktop"
set "P54=Mega.MEGASync"
:: SECURITY
set "P55=Malwarebytes.Malwarebytes"
set "P56=Avast.AvastFreeAntivirus"
set "P57=DominikReichl.KeePass"
set "P58=KeePassXCTeam.KeePassXC"
set "P59=Bitwarden.Bitwarden"
set "P60=Proton.ProtonVPN"
:: UTILS
set "P61=7zip.7zip"
set "P62=Giorgiotani.Peazip"
set "P63=RARLab.WinRAR"
set "P64=voidtools.Everything"
set "P65=Microsoft.PowerToys"
set "P66=RevoUninstaller.RevoUninstaller"
set "P67=Klocman.BulkCrapUninstaller"
set "P68=AntibodySoftware.WizTree"
set "P69=WinDirStat.WinDirStat"
set "P70=JAMSoftware.TreeSize.Free"
set "P71=Piriform.CCleaner"
set "P72=Piriform.Recuva"
set "P73=Piriform.Speccy"
set "P74=CPUID.CPU-Z"
set "P75=REALiX.HWiNFO"
set "P76=Guru3D.Afterburner"
set "P77=Wagnardsoft.DisplayDriverUninstaller"
set "P78=Rufus.Rufus"
set "P79=Balena.Etcher"
set "P80=Ventoy.Ventoy"
set "P81=LIGHTNINGUK.ImgBurn"
set "P82=AutoHotkey.AutoHotkey"
set "P83=Microsoft.Sysinternals.ProcessExplorer"
set "P84=AnyDeskSoftwareGmbH.AnyDesk"
set "P85=TeamViewer.TeamViewer"
:: LOOK
set "P86=dremin.RetroBar"
set "P87=valinet.ExplorerPatcher"
set "P88=StartIsBack.StartAllBack"
set "P89=Open-Shell.Open-Shell-Menu"
set "P90=CharlesMilette.TranslucentTB"
set "P91=Rainmeter.Rainmeter"
set "P92=RamenSoftware.Windhawk"
:: DEV
set "P93=Microsoft.VisualStudioCode"
set "P94=Anysphere.Cursor"
set "P95=JetBrains.IntelliJIDEA.Community"
set "P96=Git.Git"
set "P97=GitHub.GitHubDesktop"
set "P98=Python.Python.3.12"
set "P99=OpenJS.NodeJS.LTS"
set "P100=EclipseAdoptium.Temurin.21.JDK"
set "P101=Microsoft.PowerShell"
set "P102=Microsoft.WindowsTerminal"
set "P103=Notepad++.Notepad++"
set "P104=WinMerge.WinMerge"
set "P105=PuTTY.PuTTY"
set "P106=WinSCP.WinSCP"
set "P107=TimKosse.FileZilla.Client"
set "P108=Postman.Postman"
:: RUNTIMES
set "P109=Microsoft.DotNet.DesktopRuntime.8"
set "P110=Microsoft.VCRedist.2015+.x64"
set "P111=Microsoft.VCRedist.2015+.x86"
set "P112=Microsoft.DirectX"
:: GAMING
set "P113=Valve.Steam"
set "P114=EpicGames.EpicGamesLauncher"
set "P115=GOG.Galaxy"
set "P116=Ubisoft.Connect"
set "P117=ElectronicArts.EADesktop"
set "P118=Blizzard.BattleNet"
set "P119=PrismLauncher.PrismLauncher"
set "P120=Mojang.MinecraftLauncher"
set "P121=qBittorrent.qBittorrent"
exit /b

:set_dns
echo [DNS] Setze Google DNS (8.8.8.8 / 8.8.4.4) auf allen aktiven Adaptern...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('8.8.8.8','8.8.4.4') -ErrorAction SilentlyContinue }" >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo [DNS] Fertig.
echo.
exit /b

:ensure_winget
set "PATH=%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps"
winget --version >nul 2>&1
if not errorlevel 1 (
    echo [Winget] bereits vorhanden.
    echo.
    exit /b
)

echo [Winget] fehlt - starte Komplett-Installation...
echo.

set "MSIX=%TEMP%\winget.msixbundle"
set "DEPZIP=%TEMP%\wg_deps.zip"
set "DEPDIR=%TEMP%\wg_deps"
if exist "%MSIX%" del "%MSIX%" >nul 2>&1
if exist "%DEPZIP%" del "%DEPZIP%" >nul 2>&1
if exist "%DEPDIR%" rd /s /q "%DEPDIR%" >nul 2>&1

echo [Winget 1/4] Lade App Installer Bundle...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; try { Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile '%MSIX%' -UseBasicParsing; Write-Host '  [OK] Bundle geladen.' } catch { Write-Host ('  [X] Bundle-Download fehlgeschlagen: ' + $_.Exception.Message) }"

echo [Winget 2/4] Lade Abhaengigkeiten (VCLibs, UI.Xaml, WindowsAppRuntime)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; try { Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/DesktopAppInstaller_Dependencies.zip' -OutFile '%DEPZIP%' -UseBasicParsing; Expand-Archive -Path '%DEPZIP%' -DestinationPath '%DEPDIR%' -Force; Write-Host '  [OK] Abhaengigkeiten geladen.' } catch { Write-Host ('  [X] Dependencies-Download fehlgeschlagen: ' + $_.Exception.Message) }"

echo [Winget 3/4] Entferne alte Registrierung und installiere App Installer...
if exist "%MSIX%" powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Get-AppxPackage -AllUsers *Microsoft.DesktopAppInstaller* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue } catch {}; $dep=@(Get-ChildItem -Path '%DEPDIR%' -Recurse -Filter *.appx -ErrorAction SilentlyContinue | Where-Object { $_.FullName -match 'x64' } | ForEach-Object { $_.FullName }); Write-Host ('  Abhaengigkeiten gefunden: ' + $dep.Count); try { if ($dep.Count -gt 0) { Add-AppxPackage -Path '%MSIX%' -DependencyPath $dep -ErrorAction Stop } else { Add-AppxPackage -Path '%MSIX%' -ErrorAction Stop }; Write-Host '  [OK] App Installer installiert.' } catch { Write-Host ('  [!] Fehler: ' + $_.Exception.Message) }"

set "PATH=%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps"
winget --version >nul 2>&1
if not errorlevel 1 goto winget_ok

echo [Winget 4/4] Fallback: Microsoft.WinGet.Client Repair...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; try { Install-PackageProvider -Name NuGet -Force | Out-Null; Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null; Import-Module Microsoft.WinGet.Client; Repair-WinGetPackageManager -AllUsers -Force -Latest; Write-Host '  [OK] Repair abgeschlossen.' } catch { Write-Host ('  [!] Fehler: ' + $_.Exception.Message) }"

set "PATH=%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps"
winget --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo [Winget] konnte nicht installiert werden - Programme und Upgrade werden uebersprungen.
    echo.
    set "DO_INSTALL=0"
    set "DO_UPGRADE=0"
    exit /b
)

:winget_ok
echo.
echo [Winget] ERFOLGREICH installiert.
winget --version
echo.
exit /b

:auto_setup
echo [Auto] Basiseinstellungen...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden      /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.XboxGamingOverlay* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.XboxGameOverlay* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
echo [Auto] Fertig.
echo.
exit /b

:tweak_laggy
echo [Tweak] Optimale Leistung...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul 2>&1
echo [Tweak] Fertig.
echo.
exit /b

:tweak_highend
echo [Tweak] Optik an...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9e3e078012000000 /f >nul 2>&1
echo [Tweak] Fertig.
echo.
exit /b

:set_dark
echo [Theme] Dark...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f >nul 2>&1
echo [Theme] Fertig.
echo.
exit /b

:set_light
echo [Theme] Light...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 1 /f >nul 2>&1
echo [Theme] Fertig.
echo.
exit /b

:power_high
echo [Power] Hoechstleistung...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
if errorlevel 1 (
    powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 5f0e8b1c-3a2d-4c6e-9b7a-1d2e3f4a5b6c >nul 2>&1
    powercfg -setactive 5f0e8b1c-3a2d-4c6e-9b7a-1d2e3f4a5b6c >nul 2>&1
)
echo [Power] Fertig.
echo.
exit /b

:power_balanced
echo [Power] Ausbalanciert...
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
echo [Power] Fertig.
echo.
exit /b

:power_saver
echo [Power] Energiesparen...
powercfg -setactive a1841308-3541-4fab-bc81-f71556f20b4a >nul 2>&1
echo [Power] Fertig.
echo.
exit /b

:restart_explorer
echo [Explorer] Neustart...
taskkill /f /im explorer.exe >nul 2>&1
start "" explorer.exe
echo.
exit /b

:install_progs
if /i "%PROGS%"=="NONE" exit /b
echo.
echo [Install] Starte Installationen...
echo.
if /i "%PROGS%"=="ALL" (
    for /l %%I in (1,1,85) do call :winstall_n %%I
    for /l %%I in (93,1,%MAXP%) do call :winstall_n %%I
    exit /b
)
set "LIST=%PROGS:,= %"
for %%N in (%LIST%) do call :winstall_n %%N
exit /b

:winstall_n
set "ID="
call set "ID=%%P%~1%%"
if not defined ID (
    echo [Install] Nummer %~1 gibt es nicht - uebersprungen.
    exit /b
)
call :winstall %ID%
exit /b

:winstall
echo [Install] %~1 ...
winget install -e --id "%~1" --source winget --accept-package-agreements --accept-source-agreements
echo.
exit /b

:upgrade_all
echo.
echo [Upgrade] winget upgrade --all ...
winget upgrade --all --accept-package-agreements --accept-source-agreements
echo.
exit /b