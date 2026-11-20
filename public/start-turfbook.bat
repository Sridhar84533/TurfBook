@echo off
setlocal enabledelayedexpansion



:: 1. Define and resolve paths
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PROJECT_ROOT=%%~fI"
if not exist "%PROJECT_ROOT%\backend" (
    set "PROJECT_ROOT=%SCRIPT_DIR%"
    if "%PROJECT_ROOT:~-1%"=="\" set "PROJECT_ROOT=%PROJECT_ROOT:~0,-1%"
)

if not defined JAVA_HOME (
    set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-25.0.2.10-hotspot"
)
set "CATALINA_HOME=C:\Users\sridh\apache-tomcat-10.1.28"
set "PATH=%JAVA_HOME%\bin;%PATH%"

:: Validate Tomcat installation exists
if not exist "%CATALINA_HOME%\bin\startup.bat" (
    echo [ERROR] Tomcat 10.1 not found at: "%CATALINA_HOME%"
    echo Please verify the Tomcat path and try again.
    pause
    exit /b 1
)

:: 2. Check and deploy latest TurfBook application if WAR is built

if exist "%PROJECT_ROOT%\backend\target\turfbook.war" (
    echo [Deploy] Synchronizing latest turfbook.war to Tomcat webapps...
    copy /Y "%PROJECT_ROOT%\backend\target\turfbook.war" "%CATALINA_HOME%\webapps\turfbook.war" >nul 2>&1
) else if not exist "%CATALINA_HOME%\webapps\turfbook.war" (
    echo [Build] Packaging TurfBook with Maven...
    call mvn package -DskipTests -f "%PROJECT_ROOT%\backend\pom.xml"
    if exist "%PROJECT_ROOT%\backend\target\turfbook.war" (
        copy /Y "%PROJECT_ROOT%\backend\target\turfbook.war" "%CATALINA_HOME%\webapps\turfbook.war" >nul 2>&1
    )
)

:: 3. Free ports 8080, 8081, 8005 if lingering

for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8080" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%p >nul 2>&1
)
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8081" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%p >nul 2>&1
)
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8005" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%p >nul 2>&1
)

:: Brief pause for ports to release
ping 127.0.0.1 -n 2 >nul

:: Detect LAN IP for mobile access
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "(ipconfig | Select-String 'IPv4.*: ([\d\.]+)').Matches.Groups[1].Value"`) do (
    if not defined LAN_IP set "LAN_IP=%%i"
)
if not defined LAN_IP set "LAN_IP=localhost"

:: 4. Start Tomcat

if /I "%~1"=="run" (
    call "%CATALINA_HOME%\bin\catalina.bat" run
) else (
    call "%CATALINA_HOME%\bin\startup.bat"
)


