import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:disaster_relief_aid_flutter/view/Home.view.dart';
import 'package:disaster_relief_aid_flutter/view/Main.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../DRA.config.dart';
import '../component/DatePicker.component.dart';
import '../component/MultiSelectDropDown.component.dart';
import '../component/PasswordFormField.component.dart';

class InputProfileInfo extends StatefulWidget {
  const InputProfileInfo({super.key});

  @override
  State<InputProfileInfo> createState() => _InputProfileInfoState();
}

class _InputProfileInfoState extends State<InputProfileInfo> {
  final database = FirebaseDatabase.instance.ref();
  bool isUser = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: changeColorBasedOnUser(isUser),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            //key: _formKey,
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
                      changeUserText(isUser),
                      style: GoogleFonts.bebasNeue(
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Disaster Relief Aid",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // ignore: prefer_const_constructors
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          value: isUser,
                          activeColor: Colors.blueGrey,
                          inactiveThumbColor: Colors.red,
                          onChanged: ((value) => setState(
                                () {
                                  isUser = value;
                                },
                              )),
                        ),
                      ],
                    ),

                    //Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            // color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        // ignore: prefer_const_constructors
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          // ignore: prefer_const_constructors
                          child: CustomMultiselectDropDown(
                            listOFStrings:
                                changeConfigBasedOnUser(isUser).toList(),
                            onSelected: (List<dynamic> values) {
                              //_profile.vulnerabilities =
                              values.map((e) => e as String).toList();
                            },
                            labelText: changeLabelTextBasedOnUser(
                                isUser), //need to make black, don't now how, maybe FocusNode() ?
                            hintText: changeHintTextBasedOnUser(isUser),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                              "Continue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        onTap: () async {
                          //if (_formKey.currentState!.validate()) {
                          // _formKey.currentState!.save();
                          // ignore: use_build_context_synchronously
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) async {
                            if (user != null) {
                              String userID = user.uid;
                              final userRef = database.child('/users/');
                              final usernameEntry = userRef.child(userID);
                              try {
                                if (isUser) {
                                  await usernameEntry.update({
                                    'userType': 'User',
                                    'vulnerabilities':
                                        Config.vulnerabilities.toString()
                                  });
                                } else if (!isUser) {
                                  await usernameEntry.update({
                                    'userType': 'Volunteer',
                                    'skills': Config.skills.toString()
                                  });
                                }
                              } catch (e) {
                                print("An error has occured");
                                print(e);
                              }
                            }
                          });
                          UserInformationSingleton().loadFirebaseUser();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainView()));
                          // }
                        },
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Color? changeColorBasedOnUser(bool isUser) {
    // ignore: unused_local_variable
    Color? backgroundColor;
    if (isUser) {
      return backgroundColor = Colors.grey[300];
    }
    return backgroundColor = Color.fromARGB(201, 197, 108, 135);
  }

  String? changeLabelTextBasedOnUser(bool isUser) {
    String labelText = isUser ? "Vulnerabilites" : "Skills";
    return labelText;
  }

  String? changeHintTextBasedOnUser(bool isUser) {
    String hintText =
        isUser ? "Select your vulnerabilites" : "Select your skills";
    return hintText;
  }

  List<dynamic> changeConfigBasedOnUser(bool isUser) {
    if (isUser) {
      return Config.vulnerabilities;
    }
    return Config.skills;
  }

  String changeUserText(bool isUser) {
    String userType = (isUser ? "User" : "Volunteer");
    return userType;
  }
}
