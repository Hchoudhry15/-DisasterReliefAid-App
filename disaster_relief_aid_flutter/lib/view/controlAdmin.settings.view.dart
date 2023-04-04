// ignore_for_file: avoid_print

import 'dart:async';

import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsScreen> {
  final database = FirebaseDatabase.instance.ref();
  final _formKey = GlobalKey<FormState>();
  // User? user = UserInformationSingleton().getFirebaseUser();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Settings'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Disable User Account'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String email = "";
                    String reason = "";

                    return AlertDialog(
                      title: const Text('Disable User Account'),
                      content: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                email = value!;
                              },
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Reason'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a reason';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                reason = value!;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Confirm'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // print(getSpecificUserByEmail(email));
                              var userMAP = await getSpecificUserByEmail(email);
                              String useruid = userMAP!.keys.first;
                              addBannedUserToBannedUserDB(
                                  useruid, email, reason);
                              updateUserTypeToBanned(useruid);
                              // TODO: Implement ban user functionality using the entered email, confirmEmail, and reason values
                              //add to banned database
                              // check flag to disable the user
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future addBannedUserToBannedUserDB(
    String uid, String email, String reason) async {
  final database = FirebaseDatabase.instance.ref();
  final dbRef = database.child('/bannedUsers/');
  final bannedUserEntry = dbRef.child(uid);
  try {
    await bannedUserEntry.set({
      'Email': email,
      'Reason': reason,
    });
    print("$email added to banned users database with userID: $uid");
  } catch (e) {
    print(e);
  }
}

Future<Map<String, dynamic>?> getSpecificUserByEmail(String email) async {
  final completer = Completer<Map<String, dynamic>?>();
  var subscription;
  try {
    final databaseReference = FirebaseDatabase.instance.ref();
    subscription = databaseReference
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
    // Wait for the completer to complete or for the subscription to be canceled
    await completer.future;
  } catch (e) {
    completer.completeError(e);
  } finally {
    subscription.cancel(); // Cancel the subscription to avoid memory leaks
  }
  return completer.future;
}

Future<void> updateUserTypeToBanned(String uid) async {
  try {
    final database = FirebaseDatabase.instance.ref();
    final userRef = database.child('/users/');
    final userEntry = await userRef.child(uid).update({'userType': 'Banned'});
    print("$uid is now banned");
    return;
  } catch (e) {
    print(e);
    throw e;
  }
}
