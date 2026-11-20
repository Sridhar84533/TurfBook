@echo off
setlocal

title TurfBook - Apache Tomcat Server

echo ========================================================
echo        TurfBook - Starting Apache Tomcat 10.1
echo ========================================================
echo.

:: 1. Set Java and Tomcat paths
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-25.0.2.10-hotspot"
set "CATALINA_HOME=C:\Users\sridh\apache-tomcat-10.1.28"
set "PATH=%JAVA_HOME%\bin;%PATH%"

:: 2. Check and free port 8080 and 8081 if another process is occupying them
echo [1/3] Checking if ports 8080 and 8081 are already in use...
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8080" ^| findstr "LISTENING"') do (
    echo Terminating lingering process on port 8080 PID: %%p
    taskkill /F /PID %%p >nul 2>&1
)
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8081" ^| findstr "LISTENING"') do (
    echo Terminating lingering process on port 8081 PID: %%p
    taskkill /F /PID %%p >nul 2>&1
)

:: 3. Check and free port 8005 (shutdown port)
echo [2/3] Checking shutdown port 8005...
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8005" ^| findstr "LISTENING"') do (
    echo Terminating lingering process on port 8005 PID: %%p
    taskkill /F /PID %%p >nul 2>&1
)

:: Brief pause to ensure ports release
ping 127.0.0.1 -n 2 >nul

:: 4. Detect Wi-Fi / Local Network IP address for mobile access
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "(ipconfig | Select-String 'IPv4.*: ([\d\.]+)').Matches.Groups[1].Value"`) do (
    if not defined LAN_IP set "LAN_IP=%%i"
)
if not defined LAN_IP set "LAN_IP=localhost"

echo [3/3] Launching Tomcat with Dual Isolated Port Listeners...
echo.
echo ========================================================
echo  TurfBook is LIVE with Simultaneous Multi-Role Sessions!
echo.
echo  -------------------------------------------------------
echo  [1] USER / PLAYER PORTAL (Localhost):
echo      http://localhost:8080/turfbook
echo.
echo  [2] ADMIN OPERATIONS PORTAL (Isolated Session Domain):
echo      http://127.0.0.1:8080/turfbook/admin/turf?action=list
echo      or via Dedicated Secondary Port 8081:
echo      http://127.0.0.1:8081/turfbook/admin/turf?action=list
echo  -------------------------------------------------------
echo.
echo  MOBILE PHONE (Local Network):
echo      User:   http://%LAN_IP%:8080/turfbook
echo      Admin:  http://%LAN_IP%:8080/turfbook/login.jsp
echo.
echo  * TIP: Open User on localhost and Admin on 127.0.0.1
echo    They run simultaneously without overriding sessions!
echo ========================================================
echo.

call "%CATALINA_HOME%\bin\catalina.bat" run

echo.
echo ========================================================
echo  Tomcat has stopped.
echo ========================================================
pause
