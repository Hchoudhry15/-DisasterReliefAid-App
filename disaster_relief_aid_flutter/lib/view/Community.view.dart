import 'dart:async';

// import 'package:disaster_relief_aid_flutter/model/user.model.dart';
import 'package:disaster_relief_aid_flutter/view/ChatScreen.View.dart';
import 'package:flutter/material.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:disaster_relief_aid_flutter/Location.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:uuid/uuid.dart';

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
  String? recieverUUID;
  User? user = UserInformationSingleton().getFirebaseUser();

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
                // The getSpecificUserByEmail method returns a UserID given a User's email.
                var user = await getSpecificUserByEmail(searchText);
                // Currently we have a user map, but now we want the user's key

                setState(() {
                  if (user == null) {
                    isUserNotFound = true;
                  } else {
                    print("User found in DB");
                    isUserNotFound = false;
                    userEmail = searchText;
                    for (String key in user!.keys) {
                      recieverUUID = key;
                      break;
                    }
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
                      User? user = UserInformationSingleton().getFirebaseUser();
                      createDirectMessageThread(user!.uid, recieverUUID!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatScreenView(userEmail: userEmail!)),
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

Future<void> createDirectMessageThread(
    String userUuid, String otherUserID) async {
  try {
    final database = FirebaseDatabase.instance.ref();
    final directmessages = database.child('messages/directmessages/');
    // Within the direct message section of the database, we will create a new direct message thread and store the key.
    // We will store this key within the user's active chats so that a user may access this chat later.
    String? messageThreadKey = directmessages.push().key;
    final messageThread = directmessages.child(messageThreadKey!);
    await messageThread.update({'chatCreationDate': DateTime.now().toString()});
    final usersInChat = messageThread.child('usersInChat');
    DatabaseReference addedUser = usersInChat.push();
    await addedUser.update({
      'userId': userUuid,
    });
    DatabaseReference addedUser2 = usersInChat.push();
    await addedUser2.update({
      'userId': otherUserID,
    });

    final userActiveChats1 =
        database.child('users').child(userUuid).child('activechats');
    String? activeChat1Key = userActiveChats1.push().key;
    final userActiveChats2 =
        database.child('users').child(otherUserID).child('activechats');
    userActiveChats2.push().key;
    final activeChat2Key = userActiveChats1.push().key;
    await userActiveChats1
        .child(activeChat1Key!)
        .update({'messageThreadKey': messageThreadKey, 'isValid': true});
    await userActiveChats2
        .child(activeChat2Key!)
        .update({'messageThreadKey': messageThreadKey, 'isValid': true});
  } catch (e) {
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

Future<String?> getSpecificUserByUid(String uid) async {
  final databaseReference = FirebaseDatabase.instance.ref();
  final completer = Completer<String?>(); // create a Completer object
  databaseReference.child('users').child(uid).onValue.listen((event) {
    DataSnapshot snapshot = event.snapshot;
    String? userData = snapshot.value as String?;
    // ignore: avoid_print
    print('Updated user data: $userData');
    completer.complete(userData); // complete the Completer with the user ID
  });
  return completer.future; // return the Completer's future
}

Future<void> _fetchChatData() async {
  final database = FirebaseDatabase.instance.ref();
  final chatRef = database.child('messages/ChatRooms/');
  // get a list of all chat rooms
  final chatRoomsSnapshot = await chatRef.once();
  final chatRooms = chatRoomsSnapshot.snapshot.value as Map<String, dynamic>?;
  if (chatRooms == null) return;
  // loop through all chat rooms to get the chatted with emails
  final emails = <String>{};
  for (final chatRoom in chatRooms.values) {
    final chattedWithEmails =
        List<String>.from(chatRoom['chatted_with_emails']);
    emails.addAll(chattedWithEmails);
  }
}
