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
  //ToDo: stream: FirebaseAuth.instance.authStateChanges() so if user logged in, redirect to home screen
  runApp(const MyApp());
}
