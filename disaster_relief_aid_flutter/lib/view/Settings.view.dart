import 'package:disaster_relief_aid_flutter/model/realtimeuserinfo.model.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
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
  bool _userIsVolunteer = false;

  @override
  void initState() {
    super.initState();
    // check if user is a volunteer
    if (UserInformationSingleton().isRealtimeUserInfoLoaded()) {
      RealtimeUserInfo? user = UserInformationSingleton().getRealtimeUserInfo();
      if (user != null) {
        _userIsVolunteer = user.userType == UserType.Volunteer;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
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
      if (_userIsVolunteer)
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
              } else {
                setState(() {
                  _toggleValue = value;
                  textValue = 'Volunteer is Active';
                });
              }
              ;
            },
          ),
        ),
      if (_userIsVolunteer)
        Text(
          '$textValue',
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        )
    ]);
  }
}
