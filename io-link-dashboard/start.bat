@echo off
REM ============================================================
REM  IO-Link Dashboard launcher
REM  Double-click to start. Opens the dashboard in your browser.
REM ============================================================
cd /d "%~dp0"
title IO-Link Dashboard (AL1350)
echo Starting IO-Link Dashboard...
echo If a browser window does not open, go to: http://localhost:8088/
echo (Close this window to stop the dashboard.)
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0server.ps1"
echo.
echo Dashboard stopped.
pause
