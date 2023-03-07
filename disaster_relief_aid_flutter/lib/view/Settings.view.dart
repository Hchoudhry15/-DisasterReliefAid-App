import 'package:disaster_relief_aid_flutter/model/realtimeuserinfo.model.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:flutter/material.dart';

import 'AppInfo.view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});
  @override
  _MySettingsViewState createState() => _MySettingsViewState();
}

class _MySettingsViewState extends State<SettingsView> {
  bool _toggleValue = VolunteeringSingleton().isCurrentlyVolunteering;
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
          title: const Text('Volunteer Status'),
          subtitle: Text("You are currently ${_toggleValue ? "available" : "unavailable"} to volunteer"),
          trailing: Switch(
            value: _toggleValue,
            onChanged: (value) {
              // update the Volunteering singleton to reflect the change
              setState(() {
                _toggleValue = value;
                VolunteeringSingleton().isCurrentlyVolunteering = value;
              });
            },
          ),
        ),
    ]);
  }
}
