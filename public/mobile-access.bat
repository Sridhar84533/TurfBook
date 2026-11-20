@echo off
setlocal enabledelayedexpansion

title TurfBook - Mobile Access Assistant

echo ========================================================
echo        TurfBook - Mobile Phone Connection Helper
echo ========================================================
echo.

:: 1. Detect Local Wi-Fi IPv4 address
set "LAN_IP="
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "(ipconfig | Select-String 'IPv4.*: ([\d\.]+)').Matches.Groups[1].Value"`) do (
    if not defined LAN_IP set "LAN_IP=%%i"
)
if not defined LAN_IP set "LAN_IP=127.0.0.1"

:: 2. Check if Tomcat is running on port 8080
netstat -ano | findstr ":8080" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [!] Tomcat does NOT appear to be running.
    echo     Please start Tomcat first by double-clicking 'start-tomcat.bat'.
    echo.
) else (
    echo [OK] Tomcat is RUNNING and listening on port 8080.
    echo.
)

echo ========================================================
echo  METHOD 1: Direct Wi-Fi Access (Fastest)
echo ========================================================
echo  Make sure your mobile phone is connected to the SAME
echo  Wi-Fi network (or connect PC to your phone's hotspot).
echo.
echo  On your mobile browser (Chrome/Safari), open:
echo.
echo      http://%LAN_IP%:8080/turfbook
echo.
echo  For Admin QR Check-In / Login:
echo      http://%LAN_IP%:8080/turfbook/login.jsp
echo.
echo ========================================================
echo  METHOD 2: Public Tunnel (Works on Mobile 4G/5G/College Wi-Fi)
echo ========================================================
echo  If your mobile is on Mobile Data or college Wi-Fi blocks
echo  direct connections, you can start an instant secure tunnel.
echo.
echo  Press [T] to launch a tunnel for mobile access.
echo  Press any other key to exit.
echo ========================================================
echo.

choice /c TE /n /m "Choose [T]unnel or [E]xit: "
if errorlevel 2 goto end
if errorlevel 1 goto launch_tunnel

:launch_tunnel
echo.
echo Launching secure tunnel via localtunnel...
echo Share the generated URL to your mobile phone.
echo.
call npx -y localtunnel --port 8080
goto end

:end
echo.
pause
