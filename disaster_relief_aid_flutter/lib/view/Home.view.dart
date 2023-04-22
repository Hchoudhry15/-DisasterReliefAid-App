import 'package:disaster_relief_aid_flutter/component/HelpCallInProgressWrapper.dart';
import 'package:firebase_core/firebase_core.dart';
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
    // return Scaffold(
    //   backgroundColor: Colors.grey[300],
    //   body: SafeArea(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         // app bar
    //         Padding(
    //           padding: const EdgeInsets.symmetric(
    //             horizontal: 40.0,
    //             vertical: 25.0,
    //           ),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               // menu icon
    //               Icon(
    //                 Icons.settings,
    //                 size: 45,
    //                 color: Colors.grey[800],
    //               ),

    //               // account icon
    //               Icon(
    //                 Icons.person,
    //                 size: 45,
    //                 color: Colors.grey[800],
    //               )
    //             ],
    //           ),
    //         ),

    //         const SizedBox(height: 20.0),
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 40.0),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: const [
    //               Text("Welcome Home"),
    //               Text("Jamal Faqeeri", style: TextStyle(fontSize: 40)),
    //             ],
    //           ),
    //         )
    //         //fix later to be according to email on firebase acc
    //       ],
    //     ),
    //   ),
    // );

//   }
// }
