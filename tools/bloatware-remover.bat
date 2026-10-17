@echo off
chcp 65001 >nul
title Windows Bloatware Remover ^| Made by ConsoleCrafter ^| WinToolz 0.1

:: Administrator-Rechte prüfen
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Fordere Administratorrechte an...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ============================================================
echo                  WINDOWS BLOATWARE REMOVER
echo ============================================================
echo.

echo [1/2] Entferne unnötige vorinstallierte Windows-Apps...
echo     (Das kann 1 bis 2 Minuten dauern, bitte warten...)
echo.

:: Liste der zu entfernenden Bloatware-Pakete
set "APPS=*3DBuilder* *Microsoft3DViewer* *BingNews* *BingWeather* *MicrosoftSolitaireCollection* *GetHelp* *Getstarted* *OfficeHub* *People* *SkypeApp* *WindowsAlarms* *WindowsFeedbackHub* *WindowsMaps* *XboxApp* *XboxGamingOverlay* *XboxSpeechToTextOverlay* *YourPhone*"

for %%a in (%APPS%) do (
    echo  - Entferne %%a...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers %%a | Remove-AppxPackage -AllUsers" >nul 2>&1
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like '%%a'} | Remove-AppxProvisionedPackage -Online" >nul 2>&1
)

echo.
echo [2/2] Deaktiviere automatische App-Installationen im Hintergrund...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

echo.
echo ============================================================
echo [+] Bloatware erfolgreich entfernt und System bereinigt!
echo ============================================================
echo.
pause