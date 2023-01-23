import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:disaster_relief_aid_flutter/component/DatePicker.component.dart';
import 'package:disaster_relief_aid_flutter/component/MultiSelectDropDown.component.dart';
import 'package:google_fonts/google_fonts.dart';

import '../DRA.config.dart';

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
          child: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.public,
              size: 100,
            ),
            // ignore: prefer_const_constructors
            Text(
              "Disaster Relief Aid",
              style: GoogleFonts.bebasNeue(
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Create an Account",
              style: GoogleFonts.bebasNeue(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
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
                  ),
                ),
              ),
            ),
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
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            //confirm password
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
                          border: InputBorder.none,
                          hintText: "Confirm Password"),
                    )),
              ),
            ),
            const SizedBox(height: 10),
            //birth date
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
                  child: DatePicker(
                    label: "Birthdate",
                    onChanged: (DateTime value) {},
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            //Dropdown
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
                  child: CustomMultiselectDropDown(
                    listOFStrings: Config.vulnerabilities.toList(),
                    onSelected: (List<dynamic> values) {
                      var user; //need to implement later
                      user.vulnerabilities =
                          values.map((e) => e as String).toList();
                    },
                    labelText:
                        "Vulnerabilities", //need to make black, don't now how, maybe FocusNode() ?
                    hintText: "Select your vulnerabilities",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            //register button
            // ignore: avoid_unnecessary_containers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(25),
                // ignore: prefer_const_constructors
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text(
                  "Already Have an Account?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  " Back to Login",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ]),
        ),
      )),
    );
  }
}
