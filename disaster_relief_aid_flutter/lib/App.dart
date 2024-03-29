import 'package:disaster_relief_aid_flutter/component/HelpCallInProgressWrapper.dart';
import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        navigatorKey: navigatorKey,
        // ignore: prefer_const_constructors
        home: HelpCallInProgressWrapper(
            child: !isLoggedIn ? const LogInView() : const MainView()));
  }
}
//jamaltester@gmail.com
//airplane123
//uid : RFKkdPBPYrdQng5dDInRXFXpIYi2

//tester to send to
//chattester1@gmail.com
//airplane123