import 'dart:async';

import 'package:disaster_relief_aid_flutter/component/HelpCallInProgressWrapper.dart';
import 'package:disaster_relief_aid_flutter/singletons/HelpRequest.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:disaster_relief_aid_flutter/view/ChatScreen.View.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';
import 'package:disaster_relief_aid_flutter/view/Home.view.dart';
import 'package:disaster_relief_aid_flutter/view/Main.view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:disaster_relief_aid_flutter/view/Community.view.dart';

class HelpCallInProgressView extends StatefulWidget {
  const HelpCallInProgressView({super.key});

  @override
  State<HelpCallInProgressView> createState() => _HelpCallInProgressViewState();
}

class _HelpCallInProgressViewState extends State<HelpCallInProgressView> {
  StreamSubscription<dynamic>? stream1;

  @override
  void initState() {
    super.initState();
    stream1 = HelpRequestSingleton().onhelpRequestUpdated.listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Call in Progress"),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: HelpRequestSingleton().currentHelpRequestStatus ==
              HelpRequestStatus.ACCEPTED
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.message),
              label: const Text("Message Volunteer"),
              onPressed: () async {
                // get the user from email
                String volunteerEmail = HelpRequestSingleton().volunteerName;
                String volunteerID = HelpRequestSingleton().volunteerID;
                var user = UserInformationSingleton().getFirebaseUser();
                String isActiveChat =
                    await checkForActiveChat(user!.uid, volunteerID);

                String chatID = "";
                if (isActiveChat == "INVALID") {
                  chatID =
                      await createDirectMessageThread(user.uid, volunteerID!);
                } else {
                  print(chatID);
                  chatID = isActiveChat;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HelpCallInProgressWrapper(
                                child: ChatScreenView(
                              uid: user!.uid,
                              recieverid: volunteerID,
                              email: volunteerEmail,
                              chatid: "",
                            ))));
              })
          : null,
      body: HelpRequestSingleton().currentHelpRequestStatus ==
              HelpRequestStatus.AWAITING_RESPONSE
          ? Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Awaiting Response",
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 16),
                const CircularProgressIndicator()
              ],
            ))
          : Column(
              children: [
                ListTile(
                  title: const Text("Volunteer"),
                  subtitle: Text(HelpRequestSingleton().volunteerName),
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                            ),
                            icon: const Icon(Icons.cancel),
                            label: const Text("Cancel Request"))),
                    Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                            ),
                            icon: const Icon(Icons.check),
                            label: const Text("Mark Request as Complete")))
                  ],
                )
              ],
              // children: [
              //   ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.red,
              //       ),
              //       onPressed: () {
              //         Navigator.popUntil(context, (route) => route.isFirst);
              //       },
              //       child: const Text("Cancel Help Request"))
              // ],
            ),
    );

    // body: SingleChildScrollView(
    //     child: Column(children: [
    //   Text(
    //       "current status: " +
    //           HelpRequestSingleton().currentHelpRequestStatus.toString(),
    //       style: TextStyle(fontSize: 32, color: Colors.red)),
    //   ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.red,
    //       ),
    //       onPressed: () {
    //         Navigator.popUntil(context, (route) => route.isFirst);
    //       },
    //       child: const Text("Cancel Help Request"))
    // ])));
  }
}
