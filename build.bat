@echo off
set GRADLE_USER_HOME=%USERPROFILE%\.gradle_mealbox
echo =========================================
echo    MealBox Build-Prozess wird gestartet
echo =========================================
echo.

echo [1/3] Projekt wird bereinigt (flutter clean)...
call flutter clean
echo.

echo [2/3] Abhaengigkeiten werden geladen (flutter pub get)...
call flutter pub get
echo.

echo [3/3] APK wird gebaut (flutter build apk --debug)...
call flutter build apk --debug
echo.

echo =========================================
echo Build abgeschlossen!
echo Die fertige APK-Datei findest du unter:
echo build\app\outputs\flutter-apk\app-debug.apk
echo =========================================
pause
