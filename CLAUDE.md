# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application project (flutter_readmind). Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.

## Development Commands

### Building and Running
```bash
# Check Flutter installation and environment
flutter doctor

# Get dependencies
flutter pub get

# Run the app in debug mode
flutter run

# Run on specific device (list devices with `flutter devices`)
flutter run -d <device_id>

# Build release APK for Android
flutter build apk --release

# Build release app bundle for Android
flutter build appbundle --release

# Build for iOS (requires macOS)
flutter build ios --release

# Build for web
flutter build web --release
```

### Testing
```bash
# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format .

# Check for outdated packages
flutter pub outdated

# Upgrade packages
flutter pub upgrade
```

### Development Tools
```bash
# Generate localizations (if using intl package)
flutter gen-l10n

# Run code generation (if using packages like json_serializable, riverpod, etc.)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate code
dart run build_runner watch --delete-conflicting-outputs
```

## Architecture

### Project Structure
```
lib/
├── main.dart              # App entry point
├── screens/              # UI screens/pages
├── widgets/              # Reusable UI components
├── models/               # Data models
├── services/             # Business logic and API services
├── providers/            # State management (if using Provider/Riverpod)
├── utils/                # Utility functions and constants
├── themes/               # App theming
└── routes/               # Navigation routes

test/
├── widget_test.dart      # Basic widget tests
└── [feature]_test.dart  # Feature-specific tests

android/                 # Android-specific configuration
ios/                     # iOS-specific configuration
web/                     # Web-specific configuration
```

### State Management
This project uses **[PENDING: Choose state management approach]**. Common options in Flutter:
- **Provider** - Simple, built-in state management
- **Riverpod** - Modern, testable, and flexible
- **Bloc** - Reactive state management with clear patterns
- **GetX** - Utility-based approach with state management

### Navigation
Routes are defined in `lib/routes/app_routes.dart` (or similar). Use `Navigator.of(context)` or named routes for navigation.

### API Communication
API services are located in `lib/services/`. Consider using:
- `http` package for simple requests
- `dio` package for advanced HTTP client features
- `retrofit` for type-safe API clients

### Local Storage
For local data persistence:
- `shared_preferences` for simple key-value storage
- `sqflite` for SQLite database
- `hive` for lightweight NoSQL storage
- `drift` for type-safe SQLite with reactive queries

## Important Notes

### Platform-Specific Code
- Android configuration: `android/app/src/main/AndroidManifest.xml` and `android/app/build.gradle`
- iOS configuration: `ios/Runner/Info.plist` and `ios/Runner.xcodeproj`
- Web configuration: `web/index.html`

### Dependencies
Add packages to `pubspec.yaml` under `dependencies:` (production) or `dev_dependencies:` (development). Run `flutter pub get` after modifying.

### Assets
Declare assets (images, fonts, etc.) in `pubspec.yaml` under `flutter: assets:` section. Example:
```yaml
flutter:
  assets:
    - assets/images/
    - assets/fonts/
```

### Permissions
- Android: Add permissions in `android/app/src/main/AndroidManifest.xml`
- iOS: Add permissions in `ios/Runner/Info.plist`

## Development Workflow

1. **Before starting**: Run `flutter doctor` to ensure environment is set up correctly
2. **Install dependencies**: `flutter pub get`
3. **Run the app**: `flutter run` (hot reload with `r`, hot restart with `R`)
4. **Make changes**: Flutter supports hot reload during development
5. **Test changes**: `flutter test` or run integration tests
6. **Analyze code**: `flutter analyze` before committing
7. **Format code**: `dart format .` to maintain consistent style
8. **Build release**: `flutter build apk --release` or `flutter build ios --release`

## Common Tasks

### Adding a New Screen
1. Create screen file in `lib/screens/`
2. Add route definition in routing configuration
3. Navigate using `Navigator.push()` or named routes

### Adding a New Package
1. Add to `pubspec.yaml` under appropriate section
2. Run `flutter pub get`
3. Import and use in Dart files

### Debugging
- Use `print()` statements for quick debugging (shows in console)
- Use `debugPrint()` for production-safe logging
- Use Flutter DevTools: `flutter devtools`
- Set breakpoints in IDE (VS Code or Android Studio)

## Resources

- Flutter documentation: https://docs.flutter.dev/
- Dart documentation: https://dart.dev/guides
- Pub.dev (package repository): https://pub.dev/
- Flutter cookbook: https://docs.flutter.dev/cookbook
