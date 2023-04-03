import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/services.dart' show rootBundle;

// import app
import 'App.dart';

GlobalKey globalKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // setup singletons
  UserInformationSingleton();
  VolunteeringSingleton();

  var delegate = await LocalizationDelegate.create(
    basePath: '/Users/medhanak/Desktop/Junior Design/DisasterReliefAid-JIB-2320/disaster_relief_aid_flutter/assets',
    fallbackLocale: 'fr',
    supportedLocales: ['en_US', 'fr'],
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    
    if (user == null) {
      // print('User is currently signed out!');
      runApp(LocalizedApp(
        delegate, const MyApp(isLoggedIn: false),
      ));
      // runApp(const MyApp(isLoggedIn: false));
    } else {
      // print('User is signed in!');
      runApp(LocalizedApp(
        delegate, const MyApp(isLoggedIn: true),
      ));
      // runApp(const MyApp(isLoggedIn: true));
    }
  });
}
