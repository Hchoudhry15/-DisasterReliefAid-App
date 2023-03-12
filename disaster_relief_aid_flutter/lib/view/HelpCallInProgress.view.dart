import 'package:disaster_relief_aid_flutter/component/HelpCallInProgressWrapper.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';
import 'package:disaster_relief_aid_flutter/view/Home.view.dart';
import 'package:disaster_relief_aid_flutter/view/Main.view.dart';
import 'package:flutter/material.dart';

class HelpCallInProgressView extends StatelessWidget {
  const HelpCallInProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Help Call in Progress"),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          const Text("Help is on the way!",
              style: TextStyle(fontSize: 32, color: Colors.red)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);

                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           const HelpCallInProgressWrapper(child: MainView())),
                // );
              },
              child: const Text("Cancel Help Request"))
        ])));
  }
}
