import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maps_launcher/maps_launcher.dart';

class VolunteerCallView extends StatefulWidget {
  const VolunteerCallView({super.key});

  @override
  State<VolunteerCallView> createState() => _VolunteerCallViewState();
}

class _VolunteerCallViewState extends State<VolunteerCallView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer Call"),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text("Help Request Message"),
              subtitle:
                  Text(VolunteeringSingleton().currentHelpRequest!.message),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.map),
          label: const Text("Navigate"),
          onPressed: () {
            var latitude = VolunteeringSingleton().currentHelpRequest!.latitude;
            var longitude =
                VolunteeringSingleton().currentHelpRequest!.longitude;
            MapsLauncher.launchQuery("$latitude, $longitude");
          }),
    );
  }
}
