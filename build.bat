@echo off
setlocal
set GRADLE_USER_HOME=%USERPROFILE%\.gradle_mealbox

:menu
cls
echo =========================================
echo    MealBox Build-Menue
echo =========================================
echo [1] APK bauen (Debug - Schnelles Testen)
echo [2] APK bauen (Release - Fuer echte Geraete)
echo [3] App Bundle bauen (AAB - Play Store)
echo [4] Code bereinigen (flutter clean)
echo [5] Code analysieren (dart analyze)
echo [6] Uebersetzungen generieren (gen-l10n)
echo [0] Beenden
echo =========================================
set /p choice="Bitte waehle eine Option (0-6): "

if "%choice%"=="1" goto build_debug
if "%choice%"=="2" goto build_release
if "%choice%"=="3" goto build_aab
if "%choice%"=="4" goto clean
if "%choice%"=="5" goto analyze
if "%choice%"=="6" goto l10n
if "%choice%"=="0" goto end
goto menu

:build_debug
echo.
echo [1/3] Projekt wird bereinigt...
call flutter clean
echo [2/3] Abhaengigkeiten werden geladen...
call flutter pub get
echo [3/3] Debug APK wird gebaut...
call flutter build apk --debug
echo.
echo Die fertige APK findest du unter: build\app\outputs\flutter-apk\app-debug.apk
pause
goto menu

:build_release
echo.
echo [1/3] Projekt wird bereinigt...
call flutter clean
echo [2/3] Abhaengigkeiten werden geladen...
call flutter pub get
echo [3/3] Release APK wird gebaut...
call flutter build apk --release
echo.
echo Die fertige APK findest du unter: build\app\outputs\flutter-apk\app-release.apk
pause
goto menu

:build_aab
echo.
echo [1/3] Projekt wird bereinigt...
call flutter clean
echo [2/3] Abhaengigkeiten werden geladen...
call flutter pub get
echo [3/3] Release App Bundle wird gebaut...
call flutter build appbundle --release
echo.
echo Die fertige AAB findest du unter: build\app\outputs\bundle\release\app-release.aab
pause
goto menu

:clean
echo.
echo Projekt wird bereinigt...
call flutter clean
pause
goto menu

:analyze
echo.
echo Code wird analysiert...
call dart analyze
pause
goto menu

:l10n
echo.
echo Uebersetzungen werden generiert...
call flutter gen-l10n
pause
goto menu

:end
echo Auf Wiedersehen!
