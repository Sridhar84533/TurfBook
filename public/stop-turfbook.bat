@echo off
setlocal

title TurfBook - Stopping Server

echo ========================================================
echo        TurfBook - Stopping Application Server
echo ========================================================
echo.

set "CATALINA_HOME=C:\Users\sridh\apache-tomcat-10.1.28"
if not defined JAVA_HOME (
    set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-25.0.2.10-hotspot"
)
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo [1/2] Sending shutdown signal to Tomcat...
if exist "%CATALINA_HOME%\bin\shutdown.bat" (
    call "%CATALINA_HOME%\bin\shutdown.bat" 5 -force >nul 2>&1
)

:: Brief pause for graceful shutdown
ping 127.0.0.1 -n 2 >nul

echo [2/2] Releasing ports 8080, 8081, 8005...
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8080" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%p >nul 2>&1
)
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8081" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%p >nul 2>&1
)
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8005" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%p >nul 2>&1
)

echo.
echo ========================================================
echo  TurfBook server and ports 8080/8081 have been stopped!
echo ========================================================
echo.
