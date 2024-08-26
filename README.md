# AppSync
![Untitled-2](https://github.com/user-attachments/assets/866662a8-8f10-4c10-8c24-36fdfcdd4d61)


AppSync is a batch script designed to help manage applications on Windows using `winget`. It includes functionalities such as checking for updates, installing, and uninstalling programs.

## Features

- Check for administrative privileges
- Check if `winget` is installed and install it if necessary
- Display a user-friendly menu for various application management tasks:
  - See available updates
  - Update all applications
  - List all installed applications
  - Find a specific application
  - Get information about a specific application
  - Install the AppSync
  - Uninstall the AppSync

## Installation and Running

1. **Download and Extract**:
   - Download the `AppSync` folder from the repository.
   - Extract the contents if downloaded as a compressed file.

2. **Run the Installer**:
   - Navigate to the extracted folder.
   - Run the installer batch file: `AppSync.bat`. Choose install.
   - This will install the script and create necessary shortcuts.

3. **Run AppSync**:
   - After installation, you can run `AppSync` directly from the Start Menu or by using the provided shortcut.

### Option 2: Manual Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/makisHr03/Winget-AppSync.git
   cd AppSync


### Menu Options
![image](https://github.com/user-attachments/assets/74fba2e2-0f99-46bd-8397-2dd86615c449)


1. **See available updates**: Lists all available updates for installed applications.
2. **Update all**: Updates all installed applications to the latest version.
3. **See the list with all apps**: Displays a list of all installed applications.
4. **Find one application**: Prompts you to enter the name of an application to search for.
5. **Find information for one application**: Prompts you to enter the name of an application to get detailed information.
6. **Install the AppSync**: Installs the AppSync tool.
7. **Uninstall the AppSync**: Uninstalls the AppSync tool.
8. **Upgrade AppSync**: Upgrade the AppSync tool.
9. **Exit**: Exits the script.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Acknowledgments

- [Microsoft `winget`](https://github.com/microsoft/winget-cli) - Windows Package Manager
- [MIT License](https://opensource.org/licenses/MIT) - The license under which this project is distributed

## Contact

For any inquiries or support, please open an issue on this repository.
