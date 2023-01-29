import 'package:disaster_relief_aid_flutter/component/PasswordFormField.component.dart';
import 'package:disaster_relief_aid_flutter/view/Home.view.dart';
import 'package:flutter/material.dart';

import 'package:disaster_relief_aid_flutter/component/DatePicker.component.dart';
import 'package:disaster_relief_aid_flutter/component/MultiSelectDropDown.component.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:disaster_relief_aid_flutter/model/profile.model.dart';

import '../DRA.config.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Profile _profile = Profile();
  bool? checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.public,
                      size: 100,
                    ),
                    // ignore: prefer_const_constructors
                    Text(
                      "Disaster Relief Aid",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Log In",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 30,
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
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: "Username/Email"),
                            onSaved: (value) {
                              _profile.email = value;
                            },
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
                          child: PasswordFormField(
                            checkStrength: true,
                            onSaved: ((password) {
                              _profile.password = password;
                            }),
                            onChanged: ((newValue) {
                              _profile.password = newValue;
                            }),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.end,
                      children: [
                      TextButton(onPressed: (){}, child: const Text(
                        "Forgot Password?"
                        ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value:checkBoxValue,
                          onChanged: (value) {
                            print(value);

                            setState(() {
                              checkBoxValue = value;
                            });
                          },
                        ),
                        TextButton(onPressed: (){}, child: const Text(
                        "Terms and Conditions"
                        ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    //register button
                    // ignore: avoid_unnecessary_containers
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          // ignore: prefer_const_constructors
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            // TODO: add _profile to database
                            print(_profile);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeView()));
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          " Create Account",
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
        ));
  }
}
