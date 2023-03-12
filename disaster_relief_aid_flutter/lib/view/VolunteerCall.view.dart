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
        body: const Text("Please navigate to the User in distress."));
  }
}
