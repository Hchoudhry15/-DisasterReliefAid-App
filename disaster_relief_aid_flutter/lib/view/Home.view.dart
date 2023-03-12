import 'package:disaster_relief_aid_flutter/component/HelpCallInProgressWrapper.dart';
import 'package:flutter/material.dart';

import 'RequestHelp.view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const ListTile(
            title: Text('Disaster in your area'),
            subtitle: Text(
                'Atlanta, Georgia is currently experiencing an eduroma outage'),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            TextButton(onPressed: () {}, child: const Text('More information')),
          ])
        ])),
        Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const ListTile(
            title: Text('Do you need help?'),
            subtitle: Text(
                'Request help right away if your are in a dangerous situation.'),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpCallInProgressWrapper(
                              child: RequestHelpView())));
                },
                child: const Text('Request Help')),
          ])
        ])),
        Card(
            child:
                Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
          ListTile(
            title: Text('Disaster Relief tips'),
            subtitle: Text('During a eduroam outage, it is recommended to...'),
          ),
        ]))
      ],
    );
  }
}
