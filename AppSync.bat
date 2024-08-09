@echo off
setlocal enabledelayedexpansion

:: Check if winget command exists
winget --version >nul 2>&1
if %errorlevel% neq 0 (
    echo The winget tool is not installed!
    set /p "choice_install=Do you want to install it? (y/n): "
    goto choice_winget
) else (
    goto logo
)

:choice_winget
    if /i "%choice_install%" equ "y" (
        echo Attempting to install...
        goto admin_check_winget
    ) else if /i "%choice_install%" equ "n" (
        set "exit_script=2"
        goto logo
    ) else (
        echo Invalid choice. Please enter 'y' or 'n'.
        pause
        cls
        goto check_winget
    )

:logo
    cls
    :: Display the application logo
    echo "|    _               ____                   |"
    echo "|   / \   _ __  _ __/ ___| _   _ _ __   ___ |"
    echo "|  / _ \ | '_ \| '_ \___ \| | | | '_ \ / __||"
    echo "| / ___ \| |_) | |_) |__) | |_| | | | | (__ |"
    echo "|/_/   \_\ .__/| .__/____/ \__, |_| |_|\___||"
    echo "|        |_|   |_|         |___/            |"
    echo.
    echo.

    :: Check if the script should exit
    if "!exit_script!" equ "1" (
        echo Thanks for using the AppSync ... Bye Bye!
        echo.
        pause
        exit /b
    )
    if "!exit_script!" equ "2" (
        echo For using this tool you must have winget installed!
        echo.
        pause
        exit /b
    )
    goto menu_winget

:menu_winget
    :: Clear the option variable
    set "option="

    :: Display the main menu options
    echo 1. See available updates
    echo 2. Update all
    echo 3. See the list with all apps
    echo 4. Find one application
    echo 5. Find information for one application
    echo 6. Install AppSync
    echo 7. Uninstall AppSync
    echo 8. Exit

    :: Get user input for menu selection
    set /p option=Choose an option (1-8):

    :: Redirect to the appropriate section based on user input
    if "%option%" equ "1" goto see_available_updates
    if "%option%" equ "2" goto update_all
    if "%option%" equ "3" goto see_list
    if "%option%" equ "4" goto find_application
    if "%option%" equ "5" goto find_information
    if "%option%" equ "6" goto admin_check_install
    if "%option%" equ "7" goto admin_check_uninstall
    if "%option%" equ "8" goto exit_script

    :: If the input doesn't match any option
    echo Invalid option, please choose a valid option.
    goto menu_winget

:see_available_updates
    cls
    :: Display available updates using winget
    winget upgrade
    echo.
    set /p "choice_upgrade=Do you want to upgrade them (y/n): "
    cls
    :: Upgrade all updates if user chooses 'y'
    if /i "%choice_upgrade%" equ "y" (
        winget upgrade --all
    )
    goto logo

:update_all
    cls
    :: Update all applications using winget
    winget upgrade --all
    goto logo

:see_list
    cls
    :: Display the list of all installed applications using winget
    winget list
    echo.
    pause
    goto logo

:find_application
    cls
    :: Prompt user for the application name to search
    set /p "choice_name_application=Give the name of application: "
    echo.
    :: Search for the application using winget
    winget search "%choice_name_application%"
    echo.
    pause
    goto logo

:find_information
    cls
    :: Prompt user for the application name to get information
    set /p "choice_name_application=Give the name of application: "
    echo.
    :: Display information about the application using winget
    winget show "%choice_name_application%"
    echo.
    pause
    goto logo

:admin_check_winget
    :: Check if the script is running with administrative privileges for winget installation
    net session >nul 2>&1
    if %errorlevel% neq 0 (
        cls
        goto admin_access_winget
    ) else (
        cls
        goto install_winget
    )

:admin_check_install
    :: Check if the script is running with administrative privileges for AppSync installation
    net session >nul 2>&1
    if %errorlevel% neq 0 (
        cls
        goto admin_access_install
    ) else (
        cls
        goto perform_install
    )

:admin_check_uninstall
    :: Check if the script is running with administrative privileges for AppSync uninstallation
    net session >nul 2>&1
    if %errorlevel% neq 0 (
        cls
        goto admin_access_uninstall
    ) else (
        cls
        goto perform_uninstall
    )

:perform_install
    :: Define the target directory and shortcut paths
    set "installation_path=C:\Program Files (x86)\AppSync"
    set "shortcut_path=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AppSync.lnk"

    :: Create the target directory if it doesn't exist
    set "install_status=0"
    if not exist "%installation_path%" (
        mkdir "%installation_path%"
        set "install_status=1"
    )

    :: Copy the batch file to the target directory
    copy "%~f0" "%installation_path%" >nul

    :: Create the VBScript to create the shortcut
    set "vbs_file=create_shortcut.vbs"
    (
        echo Set WScriptShell = CreateObject("WScript.Shell"^)
        echo Set Shortcut = WScriptShell.CreateShortcut("%shortcut_path%"^)
        echo Shortcut.TargetPath = "%installation_path%\%~nx0"
        echo Shortcut.WorkingDirectory = "%installation_path%"
        echo Shortcut.Save
    ) > "%vbs_file%"

    :: Execute the VBScript
    cscript //nologo "%vbs_file%"

    :: Clean up the VBScript
    del "%vbs_file%"

    cls
    :: Display installation status
    if "%install_status%" equ "1" (
        echo The program was installed successfully!
    ) else (
        echo The program is already installed!
    )

    :: Pause to see the result
    pause
    goto logo

:perform_uninstall
    :: Define the installation folder and shortcut paths
    set "shortcut_path=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AppSync.lnk"
    set "installation_path=C:\Program Files (x86)\AppSync"

    :: Delete the installation folder if it exists
    if exist "%installation_path%" (
        rd /s /q "%installation_path%"
        echo The program was deleted successfully!
    ) else (
        echo The program is not installed!
    )

    :: Delete the shortcut if it exists
    if exist "%shortcut_path%" (
        del "%shortcut_path%"
    )

    pause
    goto logo

:exit_script
    :: Set the flag to exit the script
    set "exit_script=1"
    goto logo

:admin_access_winget
    :: Inform the user that the script is not running with admin privileges for winget installation
    echo The script is not running with administrator privileges!
    set /p "choice=Do you want to run this script with administrative privileges to install winget? (y/n): "

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

:admin_access_install
    :: Inform the user that the script is not running with admin privileges for AppSync installation
    echo The script is not running with administrator privileges!
    set /p "choice=Do you want to run this script with administrative privileges to install AppSync? (y/n): "

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
        echo If you want to install AppSync, please run the script as administrator!
        pause
        exit /b
    )

:admin_access_uninstall
    :: Inform the user that the script is not running with admin privileges for AppSync uninstallation
    echo The script is not running with administrator privileges!
    set /p "choice=Do you want to run this script with administrative privileges to uninstall AppSync? (y/n): "

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
        echo If you want to uninstall AppSync, please run the script as administrator!
        pause
        exit /b
    )

:install_winget
    :: Create a temporary PowerShell script
    set "psScript=%temp%\download_winget.ps1"
    (
        echo $progressPreference = 'silentlyContinue'
        echo Write-Output "Downloading WinGet and its dependencies..."
        echo Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
        echo Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
        echo Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
        echo Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
        echo Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
        echo Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    ) > "%psScript%"

    :: Execute the PowerShell script
    "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -File "%psScript%"

    :: Clean up
    del "%psScript%"

    :: Verify installation
    winget --version >nul 2>&1
    if %errorlevel% equ 0 (
        echo winget has been successfully installed.
    ) else (
        echo winget installation failed. Please try manually installing from the provided links.
        echo https://learn.microsoft.com/en-us/windows/package-manager/winget/
        pause
        exit /b 
    )

    goto check_winget
