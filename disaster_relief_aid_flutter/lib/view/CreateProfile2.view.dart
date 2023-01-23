import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateProfile2 extends StatefulWidget {
  const CreateProfile2({super.key});

  @override
  State<CreateProfile2> createState() => _CreateProfile2();
}

class _CreateProfile2 extends State<CreateProfile2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
          child: Column(children: [
            // ignore: prefer_const_constructors
            SizedBox(height: 25),
            const Text(
              "Disaster Relief Aid",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  // ignore: prefer_const_constructors
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      // ignore: prefer_const_constructors
                      child: TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Email"),
                      )),
                )),
            const SizedBox(height: 10),
            //password
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  // ignore: prefer_const_constructors
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      // ignore: prefer_const_constructors
                      child: TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Password"),
                      )),
                ))
          ]),
        )));
  }
}
