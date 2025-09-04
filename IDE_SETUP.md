# IDE Setup Guide for D3LTA Flutter Project

This guide will help you set up your development environment for the D3LTA Flutter project. You can use either Android Studio/IntelliJ IDEA or Visual Studio Code.

## Prerequisites

Before setting up your IDE, ensure you have the following installed:

1. Flutter SDK (version compatible with the project)
2. Dart SDK (comes with Flutter)
3. Android Studio (for Android development)
4. Xcode (for iOS development on macOS)
5. VS Code (as an alternative IDE)

## Android Studio / IntelliJ IDEA Setup

The project already contains Android Studio configuration files in the `.idea` directory.

### 1. Open the Project

1. Launch Android Studio
2. Select "Open an existing Android Studio project"
3. Navigate to the `d3lta` project directory and open it

### 2. Configure Flutter SDK

1. Go to `File` > `Settings` (Windows/Linux) or `Android Studio` > `Preferences` (macOS)
2. Navigate to `Languages & Frameworks` > `Flutter`
3. Set the Flutter SDK path to your Flutter installation directory
4. The Dart SDK path should be automatically detected

### 3. Install Required Plugins

Make sure these plugins are installed:
- Flutter
- Dart

To install plugins:
1. Go to `File` > `Settings` > `Plugins`
2. Search for "Flutter" and install it
3. The Dart plugin should be automatically installed with Flutter

### 4. Get Dependencies

1. Open the terminal in Android Studio (`View` > `Tool Windows` > `Terminal`)
2. Run `flutter pub get` to install project dependencies

## Visual Studio Code Setup

### 1. Install Extensions

Install these essential extensions from the VS Code marketplace:
- Flutter
- Dart

### 2. Open the Project

1. Launch VS Code
2. Select `File` > `Open Folder`
3. Choose the `d3lta` project directory

### 3. Configure Flutter SDK

1. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS) to open the command palette
2. Type "Flutter: Run Flutter Doctor" and select it
3. If prompted, set the Flutter SDK path to your Flutter installation directory

### 4. Get Dependencies

1. Open the integrated terminal in VS Code (`Terminal` > `New Terminal`)
2. Run `flutter pub get` to install project dependencies

## Project Structure Overview

The project follows a standard Flutter structure:
- `lib/`: Main source code
  - `main.dart`: Entry point
  - `models/`: Data models and state management
  - `screens/`: Screen widgets
  - `widgets/`: Reusable UI components
- `assets/`: Images and other assets
- `test/`: Unit and widget tests

## Running the Project

### Using Android Studio
1. Select the target device from the device selector dropdown
2. Click the "Run" button or press `Shift+F10`

### Using VS Code
1. Open the command palette (`Ctrl+Shift+P` or `Cmd+Shift+P`)
2. Type "Flutter: Select Device" and choose your target device
3. Press `F5` to start debugging or `Ctrl+F5` to run without debugging

## Code Analysis and Linting

This project uses the `flutter_lints` package for code analysis. Both IDEs should automatically highlight linting issues based on the rules defined in `analysis_options.yaml`.

## Debugging

Both IDEs provide excellent debugging support:
- Set breakpoints by clicking on line numbers
- Use the debug console to evaluate expressions
- Inspect widget trees using Flutter Inspector

## Troubleshooting

### Common Issues

1. **Flutter SDK not found**: Ensure the Flutter SDK path is correctly set in IDE settings
2. **Dependencies not found**: Run `flutter pub get` to install all dependencies
3. **Android licenses not accepted**: Run `flutter doctor --android-licenses` and accept all licenses

### Useful Commands

```bash
# Check Flutter installation
flutter doctor

# Get project dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Recommended IDE Settings

### Android Studio
- Enable "Format code on save" in `Settings` > `Tools` > `Actions on Save`
- Configure code style in `Settings` > `Editor` > `Code Style` > `Dart`

### VS Code
- Add these settings to your workspace settings (`.vscode/settings.json`):
  ```json
  {
    "dart.flutterSdkPath": "/path/to/your/flutter/sdk",
    "editor.formatOnSave": true,
    "dart.runPubGetOnPubspecChanges": true
  }
  ```

This setup will provide you with a productive development environment for working on the D3LTA Flutter project.