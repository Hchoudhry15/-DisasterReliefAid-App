import 'package:disaster_relief_aid_flutter/App.dart';
import 'package:disaster_relief_aid_flutter/model/realtimeuserinfo.model.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      if (user != null && user.userType != null) {
        _userIsVolunteer = user.userType == UserType.Volunteer;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      if (_userIsVolunteer)
        ListTile(
          title: const Text('Volunteer Status'),
          subtitle: Text(
              "You are currently ${_toggleValue ? "available" : "unavailable"} to volunteer"),
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
        title: const Text('Logout'),
        onTap: () {
          // logout
          // show a dialog to confirm logout
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Logout"),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Logout"),
                    onPressed: () async {
                      // logout
                      await FirebaseAuth.instance.signOut();
                      // go back to login screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MyApp(isLoggedIn: false),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      )
    ]);
  }
}
