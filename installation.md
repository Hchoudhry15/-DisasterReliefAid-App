# Flutter Installation

1. Download and install the Flutter CLI
2. Clone the github Repository
3. All of the app files are in the directory `/disaster_relief_aid_flutter/`, so cd into that directory using `cd disaster_relief_aid_flutter`
4. Run `flutter pub get` to install all dependencies
5. Run `flutter run` to run the app on a connected device (this is for running a debug version, not release)

# Build instructions

We have a Github workflow that will automatically build the app and upload it to the releases page whenever a commit is tagged. To build the app yourself, follow the instructions below:

**NOTE: The automated github release is currently broken. The app will build properly, but the release APK will not be able to communicate with firebase. To fix this, you will have to build the app locally.**

**Note: The release built from the Github workflow will NOT sign the app, so you will have to modify the workflow to sign the app if you want to do that, or build the app locally and sign it yourself.**

1. Download and install the Flutter CLI
2. Clone the github Repository
3. All of the app files are in the directory `/disaster_relief_aid_flutter/`, so cd into that directory using `cd disaster_relief_aid_flutter`
4. Run `flutter pub get` to install all dependencies
5. Run `flutter build apk --release` to build the app for android
6. Run `flutter build ios --release` to build the app for iOS
7. The built apps will be in the `/build/app/outputs/flutter-apk/` folder for android, and in the `/build/ios/iphoneos/Runner.app` folder for iOS

# Deployment instructions

After building the app, you can deploy it to the app store or play store. For testing purposes, you can install the app locally without the app stores. On Android, you can install the app locally using the provided APK file. On iOS, you can install the app locally using XCode.

## Android
Please view [this](https://flutter.dev/docs/deployment/android) page for instructions on how to deploy the app to the play store.

## iOS

Please view [this](https://flutter.dev/docs/deployment/ios) page for instructions on how to deploy the app to the app store.

# Testing

Check out the [testing.md](testing.md) file for information on how to write tests for the app.


# Common issues

For any issues with running the app, most of the time you can fix it by running `flutter doctor` and following the instructions to fix any issues.

Flutter also maintains a list of common issues and their fixes [here](https://github.com/flutter/flutter/wiki/Workarounds-for-common-issues).