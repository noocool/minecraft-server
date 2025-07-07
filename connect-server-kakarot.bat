@echo off
title Connect to Minecraft Server

echo =========================================================
echo.
echo      Attempting to connect to mc1.robloxs.io...
echo.
echo      This window must stay open while you play.
echo      If you close it, you will be disconnected.
echo.
echo =========================================================
echo.

:: This command starts the connection.
cloudflared.exe access tcp --hostname mc1.robloxs.io --url localhost:25565

:: The 'pause' command keeps the window open if cloudflared fails, so you can see the error.
pause