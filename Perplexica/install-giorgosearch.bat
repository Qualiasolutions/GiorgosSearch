@echo off
title GiorgosSearch Installer
color 0A

echo  _____                             _____                     _     
echo ^|  __ \                           / ____|                   ^| ^|    
echo ^| ^|  \/ ___  _ __ __ _  ___  ___ ^| (___   ___  __ _ _ __ ___^| ^|__  
echo ^| ^| __ / _ \^| '__/ _` ^|/ _ \/ __^| \___ \ / _ \/ _` ^| '__/ __^| '_ \ 
echo ^| ^|_\ \ (_) ^| ^| ^| (_^| ^| (_) \__ \ ____) ^|  __/ (_^| ^| ^| ^| (__^| ^| ^| ^|
echo  \____/\___/^|_^|  \__, ^|\___/^|___/_____/ \___^\__,_^|_^|  \___^|_^| ^|_^|
echo                   __/ ^|                                            
echo                  ^|___/                                             
echo ----------------------------------------------------------------------
echo GiorgosSearch Installer
echo ----------------------------------------------------------------------
echo.

REM Check for admin rights
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges...
) else (
    echo Warning: Not running as administrator. Some features may not work correctly.
    echo It's recommended to run this installer as administrator.
    echo.
    pause
)

REM Check if Git is installed
where git >nul 2>&1
if %errorLevel% neq 0 (
    echo Git is not installed. You need Git to download GiorgosSearch.
    echo Please install Git from https://git-scm.com/downloads
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

REM Check if Docker is installed
where docker >nul 2>&1
if %errorLevel% neq 0 (
    echo Docker is not installed. You need Docker to run GiorgosSearch.
    echo Please install Docker Desktop from https://www.docker.com/products/docker-desktop
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo All prerequisites are installed!
echo.

REM Ask for installation directory
set "default_dir=%USERPROFILE%\GiorgosSearch"
set /p "install_dir=Where would you like to install GiorgosSearch? [%default_dir%]: "

if "%install_dir%"=="" set "install_dir=%default_dir%"

REM Create the directory if it doesn't exist
if not exist "%install_dir%" (
    echo Creating directory %install_dir%...
    mkdir "%install_dir%"
)

echo.
echo Downloading GiorgosSearch from GitHub...
echo This may take a few minutes depending on your internet connection...
echo.

cd /d "%install_dir%"

REM Clone the repository
git clone https://github.com/Qualiasolutions/GiorgosSearch.git .
if %errorLevel% neq 0 (
    echo Error downloading GiorgosSearch. Please check your internet connection and try again.
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo.
echo Download complete! 
echo.

REM Run the setup wizard
echo Running the setup wizard...
echo.

powershell -ExecutionPolicy Bypass -File setup-wizard.ps1

echo.
echo Installation complete!
echo You can start GiorgosSearch anytime by running setup-wizard.ps1 or using Docker Desktop.
echo.
echo Press any key to exit...
pause >nul 