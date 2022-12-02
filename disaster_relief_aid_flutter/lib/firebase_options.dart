// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCRRa8NM5lQeelDRsxq4wX4meL1Mq1vwtc',
    appId: '1:308081012121:web:a0b475593f82fe93f7f708',
    messagingSenderId: '308081012121',
    projectId: 'lunar-linker-366702',
    authDomain: 'lunar-linker-366702.firebaseapp.com',
    storageBucket: 'lunar-linker-366702.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXTGTcBaKrmWuPoZ0Q-7SxBpBUIaVNMZs',
    appId: '1:308081012121:android:a7fe8b36a26b4f84f7f708',
    messagingSenderId: '308081012121',
    projectId: 'lunar-linker-366702',
    storageBucket: 'lunar-linker-366702.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6_y73BIJMOru64omXEBAhUSRWckcFuJc',
    appId: '1:308081012121:ios:ef20fa5c7f96eb71f7f708',
    messagingSenderId: '308081012121',
    projectId: 'lunar-linker-366702',
    storageBucket: 'lunar-linker-366702.appspot.com',
    iosClientId: '308081012121-864l98cin79jk125d3a011dpqfucru85.apps.googleusercontent.com',
    iosBundleId: 'com.example.disasterReliefAidFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC6_y73BIJMOru64omXEBAhUSRWckcFuJc',
    appId: '1:308081012121:ios:ef20fa5c7f96eb71f7f708',
    messagingSenderId: '308081012121',
    projectId: 'lunar-linker-366702',
    storageBucket: 'lunar-linker-366702.appspot.com',
    iosClientId: '308081012121-864l98cin79jk125d3a011dpqfucru85.apps.googleusercontent.com',
    iosBundleId: 'com.example.disasterReliefAidFlutter',
  );
}
