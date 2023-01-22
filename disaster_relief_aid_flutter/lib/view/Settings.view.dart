import 'package:flutter/material.dart';

import 'AppInfo.view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('App Information'),
          onTap: () {
            // go to AppInfoView
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppInfoView(),
              ),
            );
          },
        ),
      ],
    );
  }
}
