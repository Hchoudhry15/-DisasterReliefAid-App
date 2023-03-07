import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

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

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      // print('User is currently signed out!');
      runApp(const MyApp(isLoggedIn: false));
    } else {
      // print('User is signed in!');
      runApp(const MyApp(isLoggedIn: true));
    }
  });
}
