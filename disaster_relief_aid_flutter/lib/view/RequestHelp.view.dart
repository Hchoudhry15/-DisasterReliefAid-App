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
            Card(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.place),
                    title: Text('Your current location will be shared'),
                  ),
                ])),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Please describe your situation',
              ),
              maxLines: 5,
            ),
            ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => HelpCallInProgressView())),
                child: const Text("Request Help"))
          ],
        ));
  }
}
