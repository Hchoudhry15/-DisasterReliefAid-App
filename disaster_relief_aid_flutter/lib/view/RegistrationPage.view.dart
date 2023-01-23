import 'package:disaster_relief_aid_flutter/component/PasswordFormField.component.dart';
import 'package:disaster_relief_aid_flutter/view/Home.view.dart';
import 'package:flutter/material.dart';

import 'package:disaster_relief_aid_flutter/component/DatePicker.component.dart';
import 'package:disaster_relief_aid_flutter/component/MultiSelectDropDown.component.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:disaster_relief_aid_flutter/model/profile.model.dart';

import '../DRA.config.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageView();
}

class _RegistrationPageView extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Profile _profile = Profile();

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
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: "Email"),
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
                            child: TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Confirm Password"),
                              validator: (value) {
                                if (value != _profile.password) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
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
                            onChanged: (DateTime value) {
                              _profile.birthdate = value;
                            },
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
                              _profile.vulnerabilities =
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
                      child: InkWell(
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
        ));
  }
}