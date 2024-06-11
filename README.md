# Reminder App

This is a simple reminder application built using Flutter with the BLoC pattern for state management. The app allows users to add, manage, and view reminders. It also triggers local notifications on mobile devices at the designated reminder times.

## Features

- Add, edit, and delete reminders.
- Schedule local notifications for reminders (mobile only).
- View a list of upcoming reminders.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed on your system:

- [Flutter](https://flutter.dev/docs/get-started/install) (version 3.22.2 or later)
- [Dart](https://dart.dev/get-dart)
- An IDE such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1. **Clone the repository:**

    ```sh
    clone this git
    cd reminder_app
    ```

2. **Install dependencies:**

    ```sh
    flutter pub get
    ```

3. **Generate Hive Type Adapters:**

    ```sh
    flutter packages pub run build_runner build
    ```

4. **Run the app:**

    ```sh
    flutter run
    ```

### Platform Specific Setup

#### Android

Ensure you have an Android device/emulator running and available for development. No additional setup is required for Android.

#### iOS

1. **Open the project in Xcode:**

    ```sh
    open ios/Runner.xcworkspace
    ```

2. **Set up iOS permissions:**

    Add the following keys to `ios/Runner/Info.plist` to request permissions for notifications:

    ```xml
    <key>UIBackgroundModes</key>
    <array>
      <string>fetch</string>
      <string>remote-notification</string>
    </array>
    <key>NSAppTransportSecurity</key>
    <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
    </dict>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>This app needs access to location always for triggering reminders.</string>
    <key>NSLocationWhenInUseUsageDescription</key>
