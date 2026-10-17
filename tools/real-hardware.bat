@echo off
chcp 65001 >nul
title Real Hardware Checker und Benchmark ^| Made by ConsoleCrafter ^| WinToolz 0.1

:: Administrator-Rechte prüfen
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Fordere Administratorrechte an...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ============================================================
echo             REAL HARDWARE CHECKER UND BENCHMARK
echo ============================================================
echo.
echo [!] Lese physische Hardware-Komponenten direkt vom BIOS/Board aus...
echo.

:: 1. ECHTES MAINBOARD AUSLESEN
echo [1/5] Mainboard und BIOS Daten:
powershell -NoProfile -ExecutionPolicy Bypass -Command "$board = Get-CimInstance Win32_BaseBoard; $bios = Get-CimInstance Win32_BIOS; Write-Host ('   - Hersteller:    ' + $board.Manufacturer); Write-Host ('   - Modell:        ' + $board.Product); Write-Host ('   - BIOS Version:  ' + $bios.SMBIOSBIOSVersion)"
echo.

:: 2. ECHTER CPU-CHIP
echo [2/5] CPU Physische Spezifikationen:
powershell -NoProfile -ExecutionPolicy Bypass -Command "$cpu = Get-CimInstance Win32_Processor; Write-Host ('   - CPU Name:      ' + $cpu.Name); Write-Host ('   - Kerne (Echt):  ' + $cpu.NumberOfCores); Write-Host ('   - Threads:       ' + $cpu.NumberOfLogicalProcessors); Write-Host ('   - Sockel:        ' + $cpu.SocketDesignation)"
echo.

:: 3. ECHTER RAM (PHYSISCHE STICKS ZÄHLEN)
echo [3/5] Arbeitsspeicher (Physische Module):
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ram = Get-CimInstance Win32_PhysicalMemory; $totalGb = [math]::Round(($ram | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2); Write-Host ('   - Gesamt-RAM (Echt): ' + $totalGb + ' GB'); $i = 1; foreach ($stick in $ram) { $gb = [math]::Round($stick.Capacity / 1GB, 2); Write-Host ('   - Riegel ' + $i + ': ' + $gb + ' GB | ' + $stick.Speed + ' MHz | ' + $stick.Manufacturer + ' | ' + $stick.PartNumber); $i++ }"
echo.

:: 4. GRAFIKKARTE (GPU) - AKKURATER VRAM FIX VIA REGISTRY/DISPLAY
echo [4/5] Grafikkarte (Echter Hardware-ID Check):
powershell -NoProfile -ExecutionPolicy Bypass -Command "$gpus = Get-CimInstance Win32_VideoController; foreach ($gpu in $gpus) { $vram = 0; $regPath = 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\*'; $match = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue | Where-Object { $_.DriverDesc -eq $gpu.Name }; if ($match.'HardwareInformation.qwMemorySize') { $vram = [math]::Round($match.'HardwareInformation.qwMemorySize' / 1GB, 2) } else { $vram = [math]::Round([uint64]$gpu.AdapterRAM / 1GB, 2) }; Write-Host ('   - Name: ' + $gpu.Name); Write-Host ('   - VRAM: ' + $vram + ' GB'); Write-Host ('   - Treiber Version: ' + $gpu.DriverVersion) }"
echo.

:: 5. HARDWARE REALITÄTS-TEST (BENCHMARK)
echo [5/5] Starte Echtzeit-Echtheitstest (Math-Stress und Speicherdurchsatz)...
echo     (Bitte 5 bis 10 Sekunden warten...)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$sw = [System.Diagnostics.Stopwatch]::StartNew(); $result = 0; for ($i = 0; $i -lt 5000000; $i++) { $result += [math]::Sqrt($i) }; $sw.Stop(); $cpuTime = $sw.ElapsedMilliseconds; $memTest = New-Object byte[] (100MB); $sw.Restart(); for ($i = 0; $i -lt $memTest.Length; $i += 4096) { $memTest[$i] = 1 }; $sw.Stop(); $memTime = $sw.ElapsedMilliseconds; Write-Host ''; Write-Host '============================================================' -ForegroundColor Cyan; Write-Host '                     TEST ERGEBNISSE' -ForegroundColor Cyan; Write-Host '============================================================' -ForegroundColor Cyan; Write-Host ('[+] CPU Math-Test (5 Mio Iterationen): ' + $cpuTime + ' ms'); Write-Host ('[+] RAM-Zugriffs-Speedtest (100MB Block): ' + $memTime + ' ms'); if ($cpuTime -gt 4500) { Write-Host '[!] WARNUNG: Die CPU-Performance ist extrem schwach.' -ForegroundColor Red } else { Write-Host '[+] CPU-Performance liegt im normalen Bereich.' -ForegroundColor Green }"

echo.
echo ============================================================
echo [+] Hardware-Check abgeschlossen!
echo ============================================================
echo.
pause