import 'package:disaster_relief_aid_flutter/App.dart';
import 'package:disaster_relief_aid_flutter/model/realtimeuserinfo.model.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:disaster_relief_aid_flutter/view/Home.view.dart';
import 'package:disaster_relief_aid_flutter/view/LogIn.view.dart';
import 'package:disaster_relief_aid_flutter/view/controlAdmin.settings.view.dart';
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
    return ListView(
      children: [
        if (_userIsVolunteer)
          ListTile(
            title: const Text('Volunteer Status'),
            subtitle: Text(
                "You are currently ${_toggleValue ? "available" : "unavailable"} to volunteer"),
            trailing: Switch(
              value: _toggleValue,
              onChanged: (value) async {
                // update the Volunteering singleton to reflect the change
                if (value == false) {
                  // user is no longer available to volunteer
                  await VolunteeringSingleton().stopVolunteering();
                } else {
                  // user is available to volunteer
                  await VolunteeringSingleton().startVolunteering();
                }
                setState(() {
                  _toggleValue = value;
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LogInView())
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        ListTile(
          title: const Text("Admin Settings"),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                String password = "";
                return AlertDialog(
                  title: const Text("Enter Password"),
                  content: TextFormField(
                    autofocus: true,
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter password",
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        // Check if the entered password is correct
                        if (password == "IAMADMIN") {
                          // Navigate to the admin settings view
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AdminSettingsScreen(),
                            ),
                          );
                        } else {
                          // Show an error message if the password is incorrect
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Incorrect password"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
