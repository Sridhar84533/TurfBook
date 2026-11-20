@echo off
setlocal

title TurfBook - Stop Apache Tomcat

echo ========================================================
echo        TurfBook - Stopping Apache Tomcat
echo ========================================================
echo.

set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-25.0.2.10-hotspot"
set "CATALINA_HOME=C:\Users\sridh\apache-tomcat-10.1.28"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo Stopping via Tomcat shutdown command...
call "%CATALINA_HOME%\bin\catalina.bat" stop 5 -force >nul 2>&1

:: Free port 8080 and 8081 if still held
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8080" ^| findstr "LISTENING"') do (
    echo Terminating lingering process on port 8080 PID: %%p
    taskkill /F /PID %%p >nul 2>&1
)
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8081" ^| findstr "LISTENING"') do (
    echo Terminating lingering process on port 8081 PID: %%p
    taskkill /F /PID %%p >nul 2>&1
)

:: Free port 8005 if still held
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8005" ^| findstr "LISTENING"') do (
    echo Terminating lingering process on port 8005 PID: %%p
    taskkill /F /PID %%p >nul 2>&1
)

echo.
echo ========================================================
echo  Tomcat and port 8080 have been completely freed!
echo ========================================================
echo.
pause
@REM //////Portal	Dedicated URL	Credentials
@REM ////////////👤 User / Player Portal	http://localhost:8080/turfbook	luffy or alex_striker / Player@123 (or create any account)
@REM //////🛡️ Admin Operations Portal	http://127.0.0.1:8081/turfbook