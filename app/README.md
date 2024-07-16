# Flutter Lottery Ticket Purchase App
This project is a mobile application designed specifically for purchasing lottery tickets.

## Getting Started
To get started with this project, you need to have Flutter installed on your system. Here are some resources to help you if you are new to Flutter:

* Lab: Write your first Flutter app
* Lab: Install Flutter

### Prerequisites
Before running the application, ensure you have the following installed and configured:

1. **Flutter SDK:** Follow the installation guide for your operating system.
2. **IDE Setup:** It's recommended to use Visual Studio Code or Android Studio. You can find the setup instructions for VS Code here and for Android Studio here.
3. **Device Emulator:** You can use an Android emulator, iOS simulator, or run it on a physical device.

## Step-by-Step Guide to Run the Application
### 1. Clone the Repository:

Open your terminal and run:
```bash Copy code
git clone https://gitlab.com/loteria-ch/lottery-chat.git
cd lottery-chat/app
```

### 2. Install Dependencies:

Navigate to the project directory and run:

```bash Copy code
flutter pub get
```

### 3. Set Up Your Device/Emulator:

* Android Emulator:
  * Open Android Studio.
  * Go to Tools > AVD Manager.
  * Create and start a new Virtual Device.
* iOS Simulator:
  * Open Xcode.
  * Go to Xcode > Preferences > Components.
  * Install a Simulator.
  * Start the Simulator from Xcode > Open Developer Tool > Simulator.
* Physical Device:
  * Connect your device via USB and enable Developer Mode and USB debugging (Android) or trust the computer (iOS).

### 4. Open the Project in Your IDE:

* Open Visual Studio Code and navigate to the project directory, or open the project directly in Android Studio.

### 5. Run the Application:

* **Visual Studio Code:** 
  * Open `main.dart` located in the `lib` folder.
  * Click the play button (▶️) in the top right corner of the editor or press F5.
  * You will be prompted to select a device. Choose your emulator or connected device.
* **Android Studio:**
  * Open `main.dart`.
  * Click the play button (▶️) in the top right corner or use the shortcut Shift + F10.
  * Select your target device from the list that appears.

## Recommended Device
For the best experience, it is recommended to run the application on an emulator or simulator that mimics a mobile device. Running it on a desktop or in a Chrome browser is possible but may not provide the full mobile experience.

## Troubleshooting
###  Flutter Doctor:
If you encounter any issues, run flutter doctor in the terminal to check your Flutter setup. Follow the provided instructions to resolve any detected issues.

```bash Copy code
flutter doctor
```

### Common Issues
* **Dependencies Not Found:** Ensure you run flutter pub get in the project directory.
* **Device Not Listed:** Make sure your emulator is running or your physical device is properly connected and recognized by your computer.

With these steps, you should be able to run the application smoothly. If you have any questions or run into issues, refer to the Flutter documentation or seek help on the Flutter community forums.

