@echo off
title EpicGames RoboCopy - Spostamento giochi Epic Games
:: ==============================================
:: EpicGames RoboCopy - by Danybit
:: Script per spostare giochi installati da Epic Games da un disco a un altro
:: Interattivo: chiede all'utente le informazioni necessarie per ogni gioco
:: Modifica il file di configurazione di Epic Games per far riconoscere il nuovo percorso
:: ==============================================

:: === INTERAZIONE CON L'UTENTE ===
echo =============================================
echo Benvenuto in EpicGames RoboCopy - Spostamento giochi Epic Games
echo =============================================

:: Chiedi nome del gioco
set /p "GAME_NAME=Inserisci il nome del gioco (es. HITMAN): "

:: Chiedi percorso sorgente
set /p "SOURCE_PATH=Inserisci il percorso completo della cartella del gioco (es. C:\Program Files\Epic Games\%GAME_NAME%): "

:: Chiedi percorso destinazione
set /p "DEST_PATH=Inserisci il percorso di destinazione (es. D:\%GAME_NAME%): "

:: Chiedi se copiare o spostare
set /p "MOVE_COPY=Copiare o spostare? (Copiare/Spostare): "

:: Chiedi se avviare Epic Games Launcher
set /p "LAUNCH_EPIC=Vuoi avviare Epic Games Launcher alla fine? (Si/No): "

:: === CONFIGURAZIONE ===

:: Verifica se l'utente ha scelto "Copiare" o "Spostare"
if /I "%MOVE_COPY%"=="Copiare" (
    set MOVE_OPTION=/COPYALL
) else if /I "%MOVE_COPY%"=="Spostare" (
    set MOVE_OPTION=/MOVE
) else (
    echo Opzione non valida, usiamo "Spostare" come predefinito.
    set MOVE_OPTION=/MOVE
)

:: Verifica se Epic Games Launcher deve essere avviato
if /I "%LAUNCH_EPIC%"=="Si" (
    set LAUNCH_OPTION=1
) else (
    set LAUNCH_OPTION=0
)

:: === INIZIO SPOTAMENTO GIOCO ===

echo ==============================
echo Spostamento di %GAME_NAME%...
echo Da: %SOURCE_PATH%
echo A:  %DEST_PATH%
echo ==============================

:: Verifica che la cartella sorgente esista
if not exist "%SOURCE_PATH%" (
    echo ERRORE: La cartella del gioco non esiste in %SOURCE_PATH%
    pause
    exit /b
)

:: Esegui la copia o spostamento dei file
echo Avvio lo spostamento con robocopy...
robocopy "%SOURCE_PATH%" "%DEST_PATH%" /E %MOVE_OPTION% /R:3 /W:5

if errorlevel 8 (
    echo ERRORE durante la copia dei file.
    pause
    exit /b
)

echo Spostamento completato correttamente. La cartella originale dovrebbe essere stata rimossa.

:: === MODIFICA DEL FILE DI CONFIGURAZIONE DI EPIC GAMES ===
echo Modifico il file di configurazione di Epic Games per riconoscere il nuovo percorso...

:: Trova la posizione del file di configurazione
set "CONFIG_FILE=%ProgramData%\Epic\UnrealEngine\Launcher\Saved\Config\Windows\Game.ini"

:: Verifica che il file di configurazione esista
if exist "%CONFIG_FILE%" (
    echo File di configurazione trovato.
    
    :: Sostituisci il vecchio percorso con quello nuovo
    powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'InstallLocation=.*\\%GAME_NAME%', 'InstallLocation=%DEST_PATH%' | Set-Content '%CONFIG_FILE%'"

    echo Il percorso è stato aggiornato nel file di configurazione.
) else (
    echo ERRORE: File di configurazione non trovato! Assicurati di avere i permessi di amministratore.
    pause
    exit /b
)

:: Se l'utente ha scelto di avviare Epic Games Launcher, fallo
if %LAUNCH_OPTION%==1 (
    echo Avvio Epic Games Launcher...
    start "" "C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"
)

:: Mostra credito con effetto figo
echo.
timeout /t 2 >nul
echo ***********************************************************
echo *                                                         *
echo *   Coded and Created by Danybit                          *
echo *   https://www.instagram.com/_danybit_/                  *
echo *                                                         *
echo ***********************************************************
timeout /t 2 >nul

echo ===========
echo COMPLETATO!
echo Ora reinstalla %GAME_NAME% dal launcher selezionando il nuovo percorso: %DEST_PATH%
echo Non serve riavviare Epic Games Launcher.
echo Quando il download parte, mettilo in pausa: il launcher rilevera' i file automaticamente.
pause
