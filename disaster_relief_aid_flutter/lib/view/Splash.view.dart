import 'package:disaster_relief_aid_flutter/view/Register.view.dart';
import 'package:flutter/material.dart';

import 'LogIn.view.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToLogIn();
  }

  _navigateToLogIn() async {
    // ignore: avoid_print
    await Future.delayed(
        // ignore: avoid_print
        const Duration(milliseconds: 3000),
        // ignore: avoid_print
        (() => print("Splash!")));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LogInView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.green[800]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(
                          Icons.public,
                          color: Colors.green,
                          size: 75.0,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    const Text("Disaster Relief Aid",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold))
                  ],
                )),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      CircularProgressIndicator(color: Colors.white),
                      Padding(padding: EdgeInsets.only(top: 20.0))
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
