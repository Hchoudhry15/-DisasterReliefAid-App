import 'package:flutter/material.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text(
        "LogIn Screen \n needs to be implemented",
        style: TextStyle(fontSize: 20.0, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
