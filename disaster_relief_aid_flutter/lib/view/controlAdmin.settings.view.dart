import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Disable User Account'),
            onTap: () {
              // TODO: Implement ban user functionality
            },
          ),
        ],
      ),
    );
  }
}
