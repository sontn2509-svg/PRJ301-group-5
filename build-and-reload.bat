@echo off
REM ========================================================
REM Build va Reload KindergartenKitchen tren Tomcat
REM Su dung MAVEN_HOME (set trong System Environment Variables)
REM ========================================================
setlocal

REM ---- Cau hinh duong dan ----
set "PROJECT_DIR=C:\Users\hihi1\KindergartenKitchen"
set "TOMCAT_WEBAPPS=C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps"

REM ---- Kiem tra MAVEN_HOME ----
if "%MAVEN_HOME%"=="" (
    echo [LOI] Chua dat bien MAVEN_HOME.
    echo Vao: System Properties ^> Environment Variables ^> New:
    echo    Variable name : MAVEN_HOME
    echo    Variable value: C:\apache-maven-3.9.9
    echo Sau do them %%MAVEN_HOME%%\bin vao PATH.
    pause
    exit /b 1
)
set "PATH=%MAVEN_HOME%\bin;%PATH%"

echo ========================================================
echo  [1/5] Cleaning old build...
echo ========================================================
cd /d "%PROJECT_DIR%"
if exist target rmdir /s /q target

echo [2/5] Building project...
call "%MAVEN_HOME%\bin\mvn.cmd" clean package -DskipTests -q
if errorlevel 1 (
    echo BUILD FAILED!
    pause
    exit /b 1
)

if not exist "%TOMCAT_WEBAPPS%" (
    echo [CANH BAO] Khong tim thay: %TOMCAT_WEBAPPS%
    echo Hay sua TOMCAT_WEBAPPS trong file build-and-reload.bat cho khop voi may ban.
    goto :SkipDeploy
)

echo [3/5] Removing old deploy...
if exist "%TOMCAT_WEBAPPS%\KindergartenKitchen" rmdir /s /q "%TOMCAT_WEBAPPS%\KindergartenKitchen"
if exist "%TOMCAT_WEBAPPS%\KindergartenKitchen-1.0-SNAPSHOT.war" del /q "%TOMCAT_WEBAPPS%\KindergartenKitchen-1.0-SNAPSHOT.war"

echo [4/5] Copying new WAR to Tomcat...
copy /y "%PROJECT_DIR%\target\KindergartenKitchen-1.0-SNAPSHOT.war" "%TOMCAT_WEBAPPS%\" >nul

:SkipDeploy
echo [5/5] Reload Tomcat context...
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:8080/manager/text/reload?path=/KindergartenKitchen' -Method GET -UseDefaultCredentials -ErrorAction Stop } catch { Write-Host '(Reload HTTP failed - Tomcat will auto-deploy WAR in ~10s)' }"

REM ---- Reset Tomcat cache ----
REM Tim tomcat home de xoa work/Catalina/localhost/KindergartenKitchen
set "TOMCAT_HOME=%TOMCAT_WEBAPPS%\.."
if exist "%TOMCAT_HOME%\work\Catalina\localhost\KindergartenKitchen" (
    echo [Bonus] Clearing Tomcat JSP cache...
    rmdir /s /q "%TOMCAT_HOME%\work\Catalina\localhost\KindergartenKitchen" 2>nul
)

echo.
echo ========================================================
echo  XONG! Truy cap: http://localhost:8080/KindergartenKitchen
echo  Neu form van loi CSS: an Ctrl + F5 de hard reload.
echo ========================================================
pause
