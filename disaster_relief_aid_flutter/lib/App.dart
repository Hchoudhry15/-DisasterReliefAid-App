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

class HandleVolunteeringRequests extends StatefulWidget {
  const HandleVolunteeringRequests({required this.isLoggedIn, super.key});

  final bool isLoggedIn;

  @override
  State<HandleVolunteeringRequests> createState() =>
      _HandleVolunteeringRequestsState();
}

class _HandleVolunteeringRequestsState
    extends State<HandleVolunteeringRequests> {
  bool activeHelpRequest = VolunteeringSingleton().currentHelpRequest != null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VolunteeringSingleton().onHelpRequestReceivedStream.listen((event) {
      if (VolunteeringSingleton().awaitingHelpRequestResponse) {
        showAlertDialog(context);
      }
    });
    VolunteeringSingleton().onHelpRequestAcceptedStream.listen((event) {
      print("accepted help request");
      setState(() {
        activeHelpRequest = VolunteeringSingleton().currentHelpRequest != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(activeHelpRequest);
    return Scaffold(
      appBar: activeHelpRequest == true
          ? AppBar(
              title: const Text("Help Request In Progress"),
              backgroundColor: Colors.red,
            )
          : null,
      body: !widget.isLoggedIn ? const LogInView() : const MainView(),
    );
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
        // accept the request
        VolunteeringSingleton().acceptHelpRequest();
        // hide the dialog
        Navigator.pop(context);

        // TODO: go to help call in progress screen
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Help Request Received!"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text("A help request has been received!"),
        Text(
            "Distance: ${VolunteeringSingleton().helpRequestDistance} meter${VolunteeringSingleton().helpRequestDistance == "1" ? '' : 's'}"),
        Text("Message: ${VolunteeringSingleton().helpRequestMessage}"),
        const Text("Would you like to help?"),
      ]),
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
