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
        home: HandleVolunteeringRequests(
          isLoggedIn: isLoggedIn,
        ));
  }
}

class HandleVolunteeringRequests extends StatelessWidget {
  const HandleVolunteeringRequests({required this.isLoggedIn, super.key});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    VolunteeringSingleton().onHelpRequestReceivedStream.listen((event) {
      
      
    });

    return !isLoggedIn ? const LogInView() : const MainView();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Decline"),
      onPressed: () {
        // deny the request
        VolunteeringSingleton().denyHelpRequest();
        // hide the dialog
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Accept"),
      onPressed: () {

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Help Request Received!"),
      content: const Text(
          "Would you like to volunteer to help this person?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
