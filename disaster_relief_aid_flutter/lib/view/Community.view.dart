import 'dart:async';

// import 'package:disaster_relief_aid_flutter/model/user.model.dart';
import 'package:disaster_relief_aid_flutter/component/HelpCallInProgressWrapper.dart';
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
  String? recieverid;
  String? chatID;
  User? user = UserInformationSingleton().getFirebaseUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Community"),
      // ),
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
                    for (String key in user.keys) {
                      recieverid = key;
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
                  onTap: () async {
                    if (userEmail != null) {
                      User? user = UserInformationSingleton().getFirebaseUser();
                      print("!!!!!!!!!!!!!!!!");
                      String isActiveChat =
                          await checkForActiveChat(user!.uid, recieverid!);
                      if (isActiveChat == "INVALID") {
                        chatID = await createDirectMessageThread(
                            user.uid, recieverid!);
                      } else {
                        print(chatID);
                        chatID = isActiveChat;
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HelpCallInProgressWrapper(
                                  child: ChatScreenView(
                                      uid: user.uid,
                                      recieverid: recieverid!,
                                      chatid: chatID!,
                                      email: userEmail!))));
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

  Future<String?> createDirectMessageThread(
      String userid, String otherUserID) async {
    try {
      final database = FirebaseDatabase.instance.ref();
      final directmessages = database.child('chats/directmessages/');
      // Within the direct message section of the database, we will create a new direct message thread and store the key.
      // We will store this key within the user's active chats so that a user may access this chat later.
      String? chatid = directmessages.push().key;
      final messageThread = directmessages.child(chatid!);
      await messageThread.set({'chatCreationDate': DateTime.now().toString()});
      final usersInChat = messageThread.child('usersInChat');
      DatabaseReference addedUser = usersInChat.push();
      await addedUser.set({
        'userId': userid,
      });
      DatabaseReference addedUser2 = usersInChat.push();
      await addedUser2.set({
        'userId': otherUserID,
      });
      final newMessageKey = messageThread.child('messages').push().key;
      final newMessage = messageThread.child('messages').child(newMessageKey!);
      await newMessage.set(
        {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'messageDetails':
              "This is the beginning of your chat${userEmail != null ? " with ${userEmail!}!" : ""}",
          'senderid': userid,
          'recieveruid': otherUserID,
        },
      );
      final userActiveChats1 =
          database.child('users').child(userid).child('activechats');
      String? activeChat1Key = userActiveChats1.push().key;
      final userActiveChats2 =
          database.child('users').child(otherUserID).child('activechats');
      userActiveChats2.push().key;
      final activeChat2Key = userActiveChats1.push().key;
      await userActiveChats1
          .child(activeChat1Key!)
          .set({'chatid': chatid, 'isValid': true});
      await userActiveChats2
          .child(activeChat2Key!)
          .set({'chatid': chatid, 'isValid': true});
      return chatid;
    } catch (e) {
      print(e);
    }
  }

  Future addMessageToDB(String chatid, String uid, String recieveruid,
      String messageDetails) async {
    try {
      final database = FirebaseDatabase.instance.ref();
      final messageRef = database.child('/chats/directmessages').child(chatid);
      final newMessageKey = messageRef.push().key;
      final newMessage = messageRef.child(newMessageKey!);
      await newMessage.set(
        {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'messageDetails': messageDetails,
          'senderid': uid,
          'recieveruid': recieveruid,
        },
      );
      print("worked");
      return chatid;
    } catch (e) {
      print("Messages: An error has occured");
      print(e);
    }
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

/* Future addMessageToDB(String uID) async {
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
*/

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

Future<String> checkForActiveChat(String? userid1, String? userid2) async {
  final database = FirebaseDatabase.instance.ref();
  final user1Ref = database.child('users').child(userid1!);
  final user1ActiveChats = <String>{};
  final user1ActiveChatsSnapshot = await user1Ref.child('activechats').once();
  final user1ActiveChatsMap =
      user1ActiveChatsSnapshot.snapshot.value as Map<String, dynamic>?;

  final user2Ref = database.child('users').child(userid2!);
  final user2ActiveChats = <String>{};
  final user2ActiveChatsSnapshot = await user2Ref.child('activechats').once();
  final user2ActiveChatsMap =
      user2ActiveChatsSnapshot.snapshot.value as Map<String, dynamic>?;

  if (user1ActiveChatsMap != null) {
    for (final chats in user1ActiveChatsMap.values) {
      for (var value in chats.values) {
        if (value.runtimeType == String) {
          user1ActiveChats.add(value);
        }
      }
    }
  }

  if (user2ActiveChatsMap != null) {
    for (final chats in user2ActiveChatsMap.values) {
      for (var value in chats.values) {
        if (value.runtimeType == String) {
          user2ActiveChats.add(value);
        }
      }
    }
  }

  final sharedChats =
      user1ActiveChats.toSet().intersection(user2ActiveChats.toSet()).toList();

  if (sharedChats.length == 1) {
    return sharedChats.first;
  } else {
    return "INVALID";
  }
/*
  final chatRef = database.child('chats/ChatRooms/');
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
*/
}
