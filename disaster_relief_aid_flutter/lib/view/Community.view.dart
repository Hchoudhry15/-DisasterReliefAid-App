import 'package:flutter/material.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:disaster_relief_aid_flutter/Location.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final database = FirebaseDatabase.instance.ref();
  final userDBref = FirebaseDatabase.instance.ref().child("users");
  String requestDetails = "";

  // make a key for the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
            ),
            const SizedBox(height: 20),
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
                      "Send Message",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                onTap: () async {
                  // do form validation
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();

                  User? user = UserInformationSingleton().getFirebaseUser();
                  if (user != null) {
                    addMessageToDB(user.uid);
                  } else {
                    // ignore: avoid_print
                    print("message did not send");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future addMessageToDB(String uID) async {
    try {
      final database = FirebaseDatabase.instance.ref();
      final userRef = database.child('/messages/');
      var userID = uID;
      final userEntry = userRef.child(userID);
      await userEntry.set(
          {'timestamp': DateTime.now().toString(), 'messageDetails': "new"});
      print("worked");
    } catch (e) {
      print("Messages: An error has occured");
      print(e);
    }
  }
  //idFrom: uid
  //idTo: uid
  //msg: msgContext
  //time: timeStamp
}
