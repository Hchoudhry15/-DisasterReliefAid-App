import 'package:disaster_relief_aid_flutter/view/RegistrationPage.view.dart';
import 'package:disaster_relief_aid_flutter/view/Splash.view.dart';
import 'package:disaster_relief_aid_flutter/view/RegistrationPage.view.dart';
import 'package:disaster_relief_aid_flutter/view/LogIn.view.dart';
import 'package:flutter/material.dart';

// import config
import 'DRA.config.dart';

// import screens
import 'view/CreateProfile.view.dart';
import 'view/Main.view.dart';

class MyApp extends StatelessWidget {
  const MyApp({required this.isLoggedIn, super.key});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    // if user is not logged in, show register screen, else show home screen
    return MaterialApp(
        title: Config.appName,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        // ignore: prefer_const_constructors
        home: !isLoggedIn ? LogInView() : MainView());
    // home: liveChatView());
  }
}
//jamaltester@gmail.com
//airplane123
//uid : RFKkdPBPYrdQng5dDInRXFXpIYi2