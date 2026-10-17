# WinToolz

Windows-Wartungs- und Setup-Tools fuer alle, die ihr System schnell aufraeumen, reparieren und neu einrichten wollen.

**Made by ConsoleCrafter | Version 0.1**

---

## Schnellstart

1. `start.bat` doppelklicken.
2. Nummer des gewuenschten Tools eingeben und Enter druecken.
3. Fertig.

Das Menue startet das gewaehlte Tool automatisch. Nach dem Tool landest du mit einer beliebigen Taste wieder im Menue.

> **Wichtig:** Fast alle Tools brauchen Administratorrechte. Die Tools fordern diese beim Start selbst an (Windows zeigt dann eine UAC-Abfrage). Das Tool wird dabei in einem neuen Fenster mit erhoehten Rechten geoeffnet.

---

## Enthaltene Tools

| Nr. | Tool | Was es macht |
|-----|------|--------------|
| 01 | System Cleaner | Raeumt Temp-Dateien, Crash-Dumps, Browser-Caches (20 Browser), GPU-Shader-Caches, Logs, Papierkorb, DNS-Cache und alte WinSxS-Sicherungen auf. |
| 02 | Context Menu Cleaner | Entfernt nervige Eintraege aus dem Rechtsklick-Menue (Clipchamp, Skype, 3D Print). |
| 03 | Bloatware Remover | Deinstalliert vorinstallierte Windows-Apps (AppX) und stoppt automatische Hintergrund-Installationen. |
| 04 | Download Structurator | Sortiert den Downloads-Ordner automatisch in Kategorien (Bilder, Videos, Musik, Dokumente, Programme, Archive, Code, 3D-Modelle). |
| 05 | Taskleisten und Icon Fixer | Setzt Icon- und Thumbnail-Cache zurueck und startet den Explorer neu (gegen weisse/leere Icons). |
| 06 | Sound und Audio Engine Fixer | Startet die Windows-Audio-Dienste neu, wenn der Sound haengt. |
| 07 | GPU Clean Driver Installer | Erkennt die verbaute Grafikkarte und installiert einen sauberen Treiber ohne Bloatware (NVIDIA / AMD / Intel). |
| 08 | Winget Ultimate Repair und Updater | Repariert Winget ueber 20 Methoden und aktualisiert danach alle installierten Programme. |
| 09 | Setup-Assistent | Interaktiver Einrichtungs-Assistent: PC-Typ, Dark/Light-Mode, Energieplan, Programm-Auswahl aus 121 Apps, Updates. |
| 10 | WLAN Passwort Anzeiger | Liest alle gespeicherten WLAN-Profile samt Passwoertern aus. |
| 11 | Real Hardware Checker und Benchmark | Liest Mainboard, BIOS, CPU, RAM und GPU direkt aus und macht einen kurzen CPU-/RAM-Test. |
| 12 | Windows Activator | Oeffnet das Aktivierungsskript von get.activated.win. |

---

## Projektstruktur

```
WinToolz/
|- start.bat          # Menue / Launcher (farbig)
|- readme.md          # Diese Datei
|- tools/             # Alle Tools
|   |- clean.bat
|   |- ctm-cleaner.bat
|   |- bloatware-remover.bat
|   |- download-structurator.bat
|   |- icon-fixer.bat
|   |- sound-fix.bat
|   |- makedriver.bat
|   |- sudo-apt-upgrade.bat
|   |- installer.bat
|   |- WLAN-PW.bat
|   |- real-hardware.bat
|   |- activator.bat
```

---

## Einheitliches Design

Alle Tools folgen demselben Aufbau:

- **Fenstertitel:** Tool Name | Made by ConsoleCrafter | WinToolz 0.1
- **Kopf-Banner:** Trennlinie + Tool-Name
- **Fuss-Banner:** Trennlinie + Ergebnis-Meldung

Neue Tools sollten genau dieses Schema uebernehmen, damit alles einheitlich bleibt.

---

## Hinweise

- Die Tools sind fuer **Windows 10/11** gedacht.
- Manche Aktionen sind nicht umkehrbar (z. B. Papierkorb leeren, Bloatware entfernen, Wiederherstellungspunkte loeschen). Vorher kurz ueberlegen, ob das gewuenscht ist.
- `start.bat` nutzt ANSI-Farben. Auf aktuellen Windows-Versionen funktioniert das ohne weitere Einstellungen.

---

Made by ConsoleCrafter | WinToolz 0.1
