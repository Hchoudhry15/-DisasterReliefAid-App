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
        const SizedBox(height: 16),
        const Text('Disasters in your area', textAlign: TextAlign.left, style: TextStyle(fontSize: 20, 
                      fontWeight: FontWeight.bold),),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const ListTile(
            title: Text('Atlanta, Georgia is currently experiencing an eduroma outage', textAlign: TextAlign.center, style: TextStyle(color: Color.fromARGB(255, 183, 173, 80), 
                      fontWeight: FontWeight.bold),),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton(onPressed: () {}, child: const Text('More information')),
          ])
        ])),
        const SizedBox(height: 16),
        const Text('Do you need help?', textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const ListTile(
            title: Text('Request help right away if you are in a dangerous situation.', textAlign: TextAlign.center,),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpCallInProgressWrapper(
                              child: RequestHelpView())));
                },
                child: const Text('Request Help', style: TextStyle(color: Colors.red),)),
          ])
        ])),
        const SizedBox(height: 16),
        const Text('Disaster Relief tips', textAlign: TextAlign.left, style: TextStyle(fontSize: 20, 
                      fontWeight: FontWeight.bold),),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
            child:
                Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
          ListTile(
            title: Text('During a eduroam outage, it is recommended to...', textAlign: TextAlign.center,),
          ),
        ]))
      ],
    );
  }
}
