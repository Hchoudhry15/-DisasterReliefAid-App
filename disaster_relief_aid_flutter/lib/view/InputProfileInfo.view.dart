import 'package:disaster_relief_aid_flutter/view/Home.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool isUser = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: changeColorBasedOnUser(isUser),
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
                    // ignore: prefer_const_constructors
                    Row(
                      children: [
                        Switch(
                          value: isUser,
                          activeColor: Colors.red,
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
                              //_profile.vulnerabilities =
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
                        onTap: () async {
                          //if (_formKey.currentState!.validate()) {
                          // _formKey.currentState!.save();
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                          // }
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
          ),
        ),
      ),
    );
  }

  Color? changeColorBasedOnUser(bool isUser) {
    var backgroundColor;
    if (isUser) {
      return backgroundColor = Colors.grey[300];
    } else {
      return backgroundColor = const Color.fromARGB(244, 197, 108, 135);
    }
  }
}
