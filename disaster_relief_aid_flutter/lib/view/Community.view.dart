import 'dart:async';

import 'package:disaster_relief_aid_flutter/view/ChatScreen.View.dart';
import 'package:flutter/material.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:disaster_relief_aid_flutter/Location.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';

import '../component/SearchBox.component.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final database = FirebaseDatabase.instance.ref();

  final _formKey = GlobalKey<FormState>();

  bool isUserNotFound = false;
  String? userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
              ),
              const SizedBox(height: 20),
              SearchBox(onSubmittedSearch: (searchText) async {
                var user = await getSpecificUserByEmail(searchText);
                setState(() {
                  if (user == null) {
                    isUserNotFound = true;
                  } else {
                    print("User not found in DB");
                    isUserNotFound = false;
                    userEmail = searchText;
                  }
                });
              }),
              if (isUserNotFound)
                const Text(
                  "User not found",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              if (userEmail != null)
                GestureDetector(
                  onTap: () {
                    if (userEmail != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreenView(userEmail: userEmail!),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(userEmail!),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Send Message",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      User? user = UserInformationSingleton().getFirebaseUser();
                      if (user != null) {
                        addMessageToDB(user.uid);
                      } else {
                        print("USER IS NULL!!!!!!");
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> getSpecificUserByEmail(String email) async {
  final completer = Completer<Map<String, dynamic>?>();
  try {
    final databaseReference = FirebaseDatabase.instance.ref();
    databaseReference
        .child('users')
        .orderByChild('fname')
        .equalTo(email)
        .onValue
        .listen((event) {
      DataSnapshot snapshot = event.snapshot;
      Object? userData = snapshot.value;
      if (userData == null) {
        completer.complete(null);
      } else {
        completer.complete(userData as Map<String, dynamic>);
      }
    });
  } catch (e) {
    completer.completeError(e);
  }
  return completer.future;
}

Future addMessageToDB(String uID) async {
  try {
    final database = FirebaseDatabase.instance.ref();
    final userRef = database.child('/messages/');
    var userID = uID;
    final userEntry = userRef.child(userID);
    await userEntry.set(
      {
        'timestamp': DateTime.now().toString(),
        'messageDetails': "finally",
      },
    );
    print("worked");
  } catch (e) {
    print("Messages: An error has occured");
    print(e);
  }
}

void getUsers() {
  final databaseReference = FirebaseDatabase.instance.ref();
  databaseReference.child('users').onValue.listen((event) {
    DataSnapshot snapshot = event.snapshot;
    Object? usersData = snapshot.value;
    // ignore: avoid_print
    print('Updated users data: $usersData');
  });
}

void getSpecificUserByUid(String uid) {
  final databaseReference = FirebaseDatabase.instance.ref();
  databaseReference.child('users').child(uid).onValue.listen((event) {
    DataSnapshot snapshot = event.snapshot;
    Object? userData = snapshot.value;
    // ignore: avoid_print
    print('Updated user data: $userData');
  });
}

  // Future<void> getSpecificUserByEmail(String email) async {
  //   final completer = Completer<void>();
  //   try {
  //     final databaseReference = FirebaseDatabase.instance.ref();
  //     databaseReference
  //         .child('users')
  //         .orderByChild('fname')
  //         .equalTo(email)
  //         .onValue
  //         .listen((event) {
  //       DataSnapshot snapshot = event.snapshot;
  //       Object? userData = snapshot.value;
  //       print('User data: $userData');
  //       completer.complete();
  //     });
  //   } catch (e) {
  //     print("User not found");
  //     completer.complete();
  //   }
  //   return completer.future;
  // }


// Future<Map<dynamic, dynamic>> getUser(String uid) async {
//   final databaseReference = FirebaseDatabase.instance.reference();
//   DataSnapshot snapshot = await databaseReference.child('users').child(uid).once();
//   Map<dynamic, dynamic> userData = snapshot.value;
//   print('Read user data: $userData');
//   return userData;
// }

  //idFrom: uid
  //idTo: uid
  //msg: msgContext
  //time: timeStamp

