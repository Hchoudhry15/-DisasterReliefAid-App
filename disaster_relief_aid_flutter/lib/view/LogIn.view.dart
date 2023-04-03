import 'package:disaster_relief_aid_flutter/component/PasswordFormField.component.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:disaster_relief_aid_flutter/view/Home.view.dart';
import 'package:disaster_relief_aid_flutter/view/Main.view.dart';
import 'package:disaster_relief_aid_flutter/view/RegistrationPage.view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:disaster_relief_aid_flutter/component/DatePicker.component.dart';
import 'package:disaster_relief_aid_flutter/component/MultiSelectDropDown.component.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:disaster_relief_aid_flutter/model/profile.model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../DRA.config.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Profile _profile = Profile();
  final database = FirebaseDatabase.instance.ref();

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey[300],
        body: SafeArea(
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
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
                    // color: Colors.grey[200],
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
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
                    // color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                // ignore: prefer_const_constructors
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  // ignore: prefer_const_constructors
                  child: PasswordFormField(
                    checkStrength: false,
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
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {}, child: const Text("Forgot Password?"))
                  ],
                )),
            const SizedBox(height: 5),
            // if there is an error, show it
            if (error != '')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
            const SizedBox(height: 5),
            //log in button
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
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _profile.email!,
                        password: _profile.password!,
                      );

                      // TODO: cache login so we don't have to log in every time
                      UserInformationSingleton().loadFirebaseUser();
                      var user = UserInformationSingleton().getFirebaseUser();
                      String uid = user!.uid;
                      var isBanned = await checkIfBanned(uid);
                      if (isBanned == "Banned") {
                        // show red text on screen that says "User is banned"
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text(
                                'User is banned: Please Contact (000) 000-0000 for support',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainView()),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      // handle exceptions
                    }
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
                MaterialButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (c) => RegistrationPage())),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
            )
          ]),
        ),
      )),
    ));
  }
}

//function returns true if banned
Future<String?> checkIfBanned(String uid) async {
  try {
    DatabaseReference dbref =
        FirebaseDatabase.instance.ref('users/$uid/userType');
    final event = await dbref.once();
    final data = event.snapshot.value;
    if (data == "Banned") {
      return "Banned";
    } else {
      return "Not Banned";
    }
  } catch (e) {
    print(e);
    return null;
  }
}


// Future<String?> checkIfBanned(String uid) async {
//   try {
//     DatabaseReference dbref =
//         FirebaseDatabase.instance.ref('users/$uid/userType');
//     dbref.onValue.listen((DatabaseEvent event) {
//       final data = event.snapshot.value;
//       if (data == "Banned") {
//         return "Banned";
//       } else {
//         return "Not Banned";
//       }
//     });
//   } catch (e) {
//     print(e);
//     return "";
//   }
// }