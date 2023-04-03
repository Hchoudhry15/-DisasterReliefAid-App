import 'dart:async';

import 'package:disaster_relief_aid_flutter/component/HelpCallInProgressWrapper.dart';
import 'package:disaster_relief_aid_flutter/singletons/HelpRequest.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';
import 'package:disaster_relief_aid_flutter/view/Home.view.dart';
import 'package:disaster_relief_aid_flutter/view/Main.view.dart';
import 'package:flutter/material.dart';

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
    stream1 = HelpRequestSingleton()
        .onhelpRequestUpdated
        .listen((event) {
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
        body: SingleChildScrollView(
            child: Column(children: [
          Text(
              "current status: " +
                  HelpRequestSingleton().currentHelpRequestStatus.toString(),
              style: TextStyle(fontSize: 32, color: Colors.red)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Cancel Help Request"))
        ])));
  }
}
