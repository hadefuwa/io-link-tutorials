@echo off
REM ============================================================
REM  IO-Link Dashboard launcher  -  double-click to run
REM  Starts the local server and opens the presentation deck.
REM ============================================================
cd /d "%~dp0"
title IO-Link Dashboard (AL1350)
echo ============================================================
echo   IO-Link Dashboard
echo   A browser will open at:  http://localhost:8088/deck.html
echo   (deck.html = slides, explorer.html = full dashboard)
echo   Close this window to stop the dashboard.
echo ============================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0server.ps1"
echo.
echo Dashboard stopped.
pause
