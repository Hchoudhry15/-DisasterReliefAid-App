import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
        body: Center(
          child: Text(
              "${VolunteeringSingleton().currentHelpRequest!.longitude}, ${VolunteeringSingleton().currentHelpRequest!.latitude}"),
        ));
  }
}
