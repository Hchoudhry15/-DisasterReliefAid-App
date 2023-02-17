import 'package:disaster_relief_aid_flutter/view/liveChat.view.dart';
import 'package:flutter/material.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';

class RequestHelpView extends StatelessWidget {
  const RequestHelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Request Help"),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const HelpCallInProgressView())),
                child: const Text("Check Status")),
            ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const liveChatView())),
                child: const Text("Chat with Volunteer"))
          ],
        ));
  }
}
