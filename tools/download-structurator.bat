@echo off
chcp 65001 >nul
title Download Structurator ^| Made by ConsoleCrafter ^| WinToolz 0.1

echo ============================================================
echo                    DOWNLOAD STRUCTURATOR
echo ============================================================
echo.

:: Zielordner festlegen (Standardsprung auf den Downloads-Ordner des Users)
set "TARGET_DIR=%USERPROFILE%\Downloads"

if not exist "%TARGET_DIR%" (
    echo [FEHLER] Downloads-Ordner wurde nicht gefunden!
    pause
    exit /b
)

cd /d "%TARGET_DIR%"

echo [1/8] Erstelle Kategorie-Ordner...
if not exist "Bilder" mkdir "Bilder"
if not exist "Videos" mkdir "Videos"
if not exist "Musik" mkdir "Musik"
if not exist "Dokumente_PDFs" mkdir "Dokumente_PDFs"
if not exist "Programme_Executables" mkdir "Programme_Executables"
if not exist "Archive_ZIPs" mkdir "Archive_ZIPs"
if not exist "Code_Projekte" mkdir "Code_Projekte"
if not exist "3D_Modelle" mkdir "3D_Modelle"

echo [2/8] Sortiere Bilder...
for %%e in (jpg jpeg png gif bmp webp svg ico psd ai) do (
    move /y "*."%%e "Bilder\" >nul 2>&1
)

echo [3/8] Sortiere Videos...
for %%e in (mp4 mkv avi mov wmv flv webm m4v) do (
    move /y "*."%%e "Videos\" >nul 2>&1
)

echo [4/8] Sortiere Musik und Audio...
for %%e in (mp3 wav flac ogg m4a wma aar) do (
    move /y "*."%%e "Musik\" >nul 2>&1
)

echo [5/8] Sortiere Dokumente und PDFs...
for %%e in (pdf doc docx xls xlsx ppt pptx txt csv epub) do (
    move /y "*."%%e "Dokumente_PDFs\" >nul 2>&1
)

echo [6/8] Sortiere Programme und Installer...
for %%e in (exe msi bat cmd ps1 vbs reg iso) do (
    :: Eigenes Skript nicht verschieben
    if /i not "%%e"=="bat" (
        move /y "*."%%e "Programme_Executables\" >nul 2>&1
    ) else (
        for %%f in (*.bat) do (
            if /i not "%%~nxf"=="%~nx0" move /y "%%f" "Programme_Executables\" >nul 2>&1
        )
    )
)

echo [7/8] Sortiere Archive und ZIPs...
for %%e in (zip rar 7z tar gz iso cab) do (
    move /y "*."%%e "Archive_ZIPs\" >nul 2>&1
)

echo [8/8] Sortiere Code und 3D-Dateien...
for %%e in (py js html css cpp c cs java json xml) do (
    move /y "*."%%e "Code_Projekte\" >nul 2>&1
)
for %%e in (stl obj fbx blend 3ds) do (
    move /y "*."%%e "3D_Modelle\" >nul 2>&1
)

echo.
echo ============================================================
echo [+] Downloads-Ordner wurde erfolgreich strukturiert!
echo ============================================================
echo.
timeout /t 3 >nul
exit