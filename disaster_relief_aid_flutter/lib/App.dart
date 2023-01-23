import 'package:disaster_relief_aid_flutter/view/Splash.view.dart';
import 'package:flutter/material.dart';

// import config
import 'DRA.config.dart';

// import screens
import 'view/Register.view.dart';
import 'view/Main.view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // check if user is logged in
    const bool isLoggedIn = false;

    // if user is not logged in, show register screen, else show home screen
    return MaterialApp(
        title: Config.appName,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        // ignore: prefer_const_constructors
        home: Splash());
  }
}
