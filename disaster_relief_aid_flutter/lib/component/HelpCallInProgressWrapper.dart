import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:disaster_relief_aid_flutter/view/VolunteerCall.view.dart';
import 'package:flutter/material.dart';

class HelpCallInProgressWrapper extends StatefulWidget {
  const HelpCallInProgressWrapper({required this.child, super.key});

  final Widget child;

  @override
  State<HelpCallInProgressWrapper> createState() =>
      _HelpCallInProgressWrapperState();
}

class _HelpCallInProgressWrapperState extends State<HelpCallInProgressWrapper> {
  bool activeHelpRequest = VolunteeringSingleton().currentHelpRequest != null;
  // bool activeHelpRequest = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VolunteeringSingleton().onHelpRequestAcceptedStream.listen((event) {
      print("accepted help request");
      if (mounted) {
        setState(() {
          activeHelpRequest =
              VolunteeringSingleton().currentHelpRequest != null;
        });
      }
    });

    VolunteeringSingleton().onHelpRequestReceivedStream.listen((event) {
      if (mounted && VolunteeringSingleton().awaitingHelpRequestResponse) {
        showAlertDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: activeHelpRequest == true
          ? AppBar(
              title: TextButton(
                child: const Text("Help Request In Progress",
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // navigate to the help call in progress screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VolunteerCallView()),
                  );
                },
              ),
              titleTextStyle: Theme.of(context).textTheme.titleLarge,
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 3,
              backgroundColor: Colors.red,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VolunteerCallView()),
                      );
                    },
                    icon: const Icon(Icons.visibility))
              ],
            )
          : null,
      body: widget.child,
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

        // // TODO: go to help call in progress screen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const VolunteerCallView()),
        // );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Help Request Received!"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
            title: const Text("Message"),
            subtitle: Text(VolunteeringSingleton().helpRequestMessage)),
        ListTile(
            title: const Text("Distance"),
            subtitle: Text(
                "${VolunteeringSingleton().helpRequestDistance} meter${VolunteeringSingleton().helpRequestDistance == "1" ? '' : 's'}")),
        const ListTile(title: Text("Would you like to help?")),
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
