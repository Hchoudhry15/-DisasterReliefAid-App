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
import 'package:geolocator/geolocator.dart';

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

                List<String?> recieverIDs = [volunteerID];
                String recieverEmails = volunteerEmail;

                String isActiveChat =
                    await checkForActiveChat(user!.uid, recieverIDs);
                String? chatID;
                if (isActiveChat == "INVALID") {
                  chatID = await createDirectMessageThread(
                      user.uid, recieverIDs, recieverEmails);
                } else {
                  chatID = isActiveChat;
                }

                var database = FirebaseDatabase.instance.ref();

                final databasestuff =
                    await database.child('/users').child(user.uid).get();
                final senderEmail = (Map<String, dynamic>.from(
                    databasestuff.value as Map)['fname']);
                Map<String, String> uIDToEmailMap = new Map();
                uIDToEmailMap[user.uid] = senderEmail;
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HelpCallInProgressWrapper(
                            child: ChatScreenView(
                                uid: user.uid,
                                recieverids: recieverIDs,
                                chatid: chatID!,
                                recieverEmail: recieverEmails,
                                senderEmail: senderEmail,
                                uIDToEmailMap: uIDToEmailMap))));
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
                ListTile(
                  title: const Text("Volunteer Location"),
                  subtitle: Text(
                      "${HelpRequestSingleton().volunteerDistance.toStringAsFixed(2)}${HelpRequestSingleton().volunteerDistanceUnit} away"),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  // confirm with dialog
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text("Confirm Cancel"),
                                            content: const Text(
                                                "Are you sure you want to cancel the request?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Cancelling Request...")));
                                                    try {
                                                      HelpRequestSingleton()
                                                          .cancelHelpRequest();
                                                      Navigator.popUntil(
                                                          context,
                                                          (route) =>
                                                              route.isFirst);
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(e
                                                                  .toString())));
                                                    }
                                                  },
                                                  child: const Text("Yes"))
                                            ],
                                          ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 16),
                                ),
                                icon: const Icon(Icons.cancel),
                                label: const Text("Cancel Request"))),
                        Expanded(
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  // confirm with dialog
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title:
                                                const Text("Confirm Complete"),
                                            content: const Text(
                                                "Are you sure you want to mark the request as complete?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Marking Request as Complete...")));
                                                    try {
                                                      HelpRequestSingleton()
                                                          .markHelpRequestAsCompleted();
                                                      Navigator.popUntil(
                                                          context,
                                                          (route) =>
                                                              route.isFirst);
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(e
                                                                  .toString())));
                                                    }
                                                  },
                                                  child: const Text("Yes"))
                                            ],
                                          ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 16),
                                ),
                                icon: const Icon(Icons.check),
                                label: const Text("Mark Request as Complete")))
                      ],
                    ))
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
