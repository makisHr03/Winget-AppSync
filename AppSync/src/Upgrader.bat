@echo off

    net session >nul 2>&1
    if %errorlevel% neq 0 (
        cls
        goto admin_access
    ) else (
        cls
        goto upgrade
    )


:admin_access
    :: Inform the user that the script is not running with admin privileges for winget installation
    echo The script is not running with administrator privileges!
    set /p "choice=Do you want to run this script with administrative privileges to Upgrade AppSync? (y/n): "

    :: Prompt to rerun the script with admin privileges if the user chooses 'y'
    if /i "%choice%" equ "y" (
        :: Create a VBScript to request admin privileges
        echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
        echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %*", "", "runas", 1 >> "%temp%\getadmin.vbs"
        
        :: Execute the VBScript and delete it
        "%temp%\getadmin.vbs"
        del "%temp%\getadmin.vbs"
        exit /b
    ) else (
        echo If you want to install winget, please run the script as administrator!
        pause
        exit /b
    )

:upgrade
:: Step 1: Delete the existing AppSync.bat if it exists
set "installation_path=C:\Program Files (x86)\AppSync"

if exist "%installation_path%\AppSync.bat" (
    del "%installation_path%\AppSync.bat"
)

:: Step 2: Download the new AppSync.bat using curl with SSL verification disabled
curl -k -o "%installation_path%\AppSync.bat" https://raw.githubusercontent.com/makisHr03/Winget-AppSync/master/AppSync/AppSync.bat

:: Step 3: Check if the download was successful
if exist "%installation_path%\AppSync.bat" (
    :: Step 4: Run the new AppSync.bat
    "%installation_path%\AppSync.bat"
) else (
    echo Download failed. Please check your internet connection or the URL.
)

pause

pause

