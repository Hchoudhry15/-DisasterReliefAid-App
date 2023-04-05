# Flutter Installation

1. Download and install the Flutter CLI
2. Clone the github Repository
3. Run `flutter pub get` to install all dependencies
4. Run `flutter run` to run the app on a connected device (this is for running a debug version, not release)

# Build instructions

We have a Github workflow that will automatically build the app and upload it to the releases page. To build the app yourself, follow the instructions below:

Note: The release built from the Github workflow will NOT sign the app, so you will have to modify the workflow to sign the app if you want to do that, or build the app locally and sign it yourself.

1. Download and install the Flutter CLI
2. Clone the github Repository
3. Run `flutter pub get` to install all dependencies
4. Run `flutter build apk --release` to build the app for android
5. Run `flutter build ios --release` to build the app for iOS
6. The built apps will be in the `/build/app/outputs/flutter-apk/` folder for android, and in the `/build/ios/iphoneos/Runner.app` folder for iOS

# Deployment instructions

After building the app, you can deploy it to the app store or play store. For testing purposes, you can install the app locally without the app stores. On Android, you can install the app locally using the provided APK file. On iOS, you can install the app locally using XCode.

# Testing

Check out the [testing.md](testing.md) file for information on how to write tests for the app.
