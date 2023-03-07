import 'package:flutter/material.dart';

import 'AppInfo.view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key}); 
  @override
  _MySettingsViewState createState() => _MySettingsViewState();
}

class _MySettingsViewState extends State<SettingsView> {
  bool _toggleValue = false;
  var textValue = 'Volunteer is not Active'; 

  @override
  void initState() {
    super.initState();
    // check if user is a volunteer
    
  }

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
        ListTile(
          title: Text('Status'),
          trailing: Switch(
            value: _toggleValue,
            onChanged: (value) {
              if (_toggleValue == true) {
                setState(() {
                  _toggleValue = value;
                  textValue = 'Volunteer is not Active';
                });
              }
              else {
                setState(() {
                  _toggleValue = value;
                  textValue = 'Volunteer is Active';
                });
              };
            },
          ),
        ),
        Text('$textValue', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,)
      ]
    );
  }
}