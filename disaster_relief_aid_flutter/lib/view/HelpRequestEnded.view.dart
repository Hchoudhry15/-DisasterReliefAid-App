import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HelpRequestEndedView extends StatelessWidget {
  const HelpRequestEndedView(
      {this.isVolunteer = false, this.isCompleted = false, super.key});

  final bool isVolunteer;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    String message = "";
    if (isVolunteer) {
      if (isCompleted) {
        message = "You have ended your help call";
      } else {
        message = "You have cancelled your help call";
      }
    } else {
      if (isCompleted) {
        message = "Your help call has ended";
      } else {
        message = "Your help call has been cancelled";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Request Ended"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                label: const Text("Return Home"),
                icon: const Icon(Icons.home))
          ],
        ),
      ),
    );
  }
}
