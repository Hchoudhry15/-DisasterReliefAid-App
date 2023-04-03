import 'dart:async';
import 'dart:math';

// import 'package:disaster_relief_aid_flutter/model/user.model.dart';
import 'package:disaster_relief_aid_flutter/component/HelpCallInProgressWrapper.dart';
import 'package:disaster_relief_aid_flutter/view/ChatScreen.View.dart';
import 'package:disaster_relief_aid_flutter/view/Home.view.dart';
import 'package:disaster_relief_aid_flutter/view/Settings.view.dart';
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
  Map<List<String>, String> emailsToChatMap = {};

  final _formKey = GlobalKey<FormState>();

  bool invalidUserEntry = false;
  String? recieverEmails;
  String? recieverid;
  String? chatID;
  User? user = UserInformationSingleton().getFirebaseUser();
  List<String?> listOfUserEmails = [];
  List<String?> recieverIDs = [];

  void handleAwait() async {
    List<String?> activeChats = await getUsersActiveChats(user!.uid);
    List<String> iterableActiveChats =
        activeChats.where((chat) => chat != null).cast<String>().toList();
    var userIDsToChatMap = await getUserActiveChatHelper(iterableActiveChats);
    emailsToChatMap = await getUserEmailMapFromUserIdMap(userIDsToChatMap);
    setState(() {
      emailsToChatMap = emailsToChatMap;
    });
    print("************");
    print(emailsToChatMap);
  }

  void initState() {
    super.initState();
    handleAwait();
  }

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
                // The user enters multiple emails seperated by ,
                List<String> invalidUsers = [];
                List<String?> testListOfUserEmails = searchText.split(',');
                for (int i = 0; i < testListOfUserEmails.length; i++) {
                  testListOfUserEmails[i] = testListOfUserEmails[i]?.trim();
                  var u = testListOfUserEmails[i];
                  var userIDMap = await getSpecificUserByEmail(u!);
                  if (userIDMap == null) {
                    invalidUsers.add(u);
                  } else {
                    for (String key in userIDMap.keys) {
                      //The first element in the map's keyset is the id of a user
                      recieverIDs.add(key);
                      break;
                    }
                  }
                }
                //var user = await getSpecificUserByEmail(searchText);
                // Currently we have a user map, but now we want the user's key

                setState(() {
                  if (invalidUsers.isNotEmpty && listOfUserEmails.isNotEmpty) {
                    invalidUserEntry = true;
                  } else {
                    print("All users found within DB");
                    listOfUserEmails = searchText.split(',');
                    for (int i = 0; i < listOfUserEmails.length; i++) {
                      listOfUserEmails[i] = listOfUserEmails[i]?.trim();
                    }
                    invalidUserEntry = false;
                    recieverEmails = searchText;
                  }
                });
              }),
              if (invalidUserEntry)
                const Text(
                  "One or more users not found",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              if (listOfUserEmails.isNotEmpty)
                GestureDetector(
                  onTap: () async {
                    if (listOfUserEmails.isNotEmpty) {
                      User? user = UserInformationSingleton().getFirebaseUser();
                      String isActiveChat =
                          await checkForActiveChat(user!.uid, recieverIDs);
                      print("UserId" + user.uid);
                      print("RecieverIDs" + recieverIDs.toString());
                      if (isActiveChat == "INVALID") {
                        chatID = await createDirectMessageThread(
                            user.uid, recieverIDs);
                      } else {
                        print(chatID);
                        chatID = isActiveChat;
                      }

                      final databasestuff =
                          await database.child('/users').child(user.uid).get();
                      print("HELLO!!!!!!!!!!!!!!");
                      final senderEmail = (Map<String, dynamic>.from(
                          databasestuff.value as Map)['fname']);
                      Map<String, String> uIDToEmailMap = new Map();
                      uIDToEmailMap[user.uid] = senderEmail;
                      for (int i = 0; i < recieverIDs.length; i++) {
                        uIDToEmailMap[recieverIDs[i]!] = listOfUserEmails[i]!;
                      }
                      print(uIDToEmailMap);
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HelpCallInProgressWrapper(
                                  child: ChatScreenView(
                                      uid: user.uid,
                                      recieverids: recieverIDs,
                                      chatid: chatID!,
                                      recieverEmail: recieverEmails!,
                                      senderEmail: senderEmail,
                                      uIDToEmailMap: uIDToEmailMap))));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(recieverEmails!),
                  ),
                ),
              SizedBox(
                height: 500,
                child: ListView.builder(
                  itemCount: emailsToChatMap.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: getRandomColor(),
                        ),
                        title: Text(
                          emailsToChatMap.keys
                              .toList()[index]
                              .toString()
                              .substring(
                                  1,
                                  emailsToChatMap.keys
                                          .toList()[index]
                                          .toString()
                                          .length -
                                      1),
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: GestureDetector(
                          onTap: () async {
                            List<String?> activeChats =
                                await getUsersActiveChats(user!.uid);
                            List<String> iterableActiveChats = activeChats
                                .where((chat) => chat != null)
                                .cast<String>()
                                .toList();
                            var userIDsToChatMap =
                                await getUserActiveChatHelper(
                                    iterableActiveChats);
                            emailsToChatMap =
                                await getUserEmailMapFromUserIdMap(
                                    userIDsToChatMap);

                            //
                            // handle message icon click here
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const HelpCallInProgressView()));
                            //random view used for now
                            // ignore: todo
                            //TODO: backend need to chatScreen view
                            //     child: ChatScreenView(
                            //         uid: user!.uid,
                            //         recieverid: recieverid!,
                            //         chatid: chatID!,
                            //         email: userEmail!))));
                            // ignore: avoid_print
                            print(
                                "Message icon clicked for chat${emailsToChatMap[emailsToChatMap.keys.toList()[index]]}");
                          },
                          child: const Icon(Icons.message, color: Colors.blue),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Future<String?> createDirectMessageThread(
      String userid, List<String?> otherUserIDs) async {
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
      for (String? otherUserID in otherUserIDs) {
        DatabaseReference addedUser2 = usersInChat.push();
        await addedUser2.set({
          'userId': otherUserID,
        });
      }

      final newMessageKey = messageThread.child('messages').push().key;
      final newMessage = messageThread.child('messages').child(newMessageKey!);

      for (String? otherUserID in otherUserIDs) {
        await newMessage.set(
          {
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'messageDetails':
                "This is the beginning of your chat${recieverEmails != null ? " with ${recieverEmails!}!" : ""}",
            'senderid': userid,
            'recieveruid': otherUserID,
          },
        );
      }

      final userActiveChats1 =
          database.child('users').child(userid).child('activechats');
      String? activeChat1Key = userActiveChats1.push().key;
      await userActiveChats1
          .child(activeChat1Key!)
          .set({'chatid': chatid, 'isValid': true});

      for (String? otherUserID in otherUserIDs) {
        final userActiveChats2 =
            database.child('users').child(otherUserID!).child('activechats');
        userActiveChats2.push().key;
        final activeChat2Key = userActiveChats1.push().key;
        await userActiveChats2
            .child(activeChat2Key!)
            .set({'chatid': chatid, 'isValid': true});
      }

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

Future<String> checkForActiveChat(
    String? userid1, List<String?> recieverids) async {
  final database = FirebaseDatabase.instance.ref();
  final user1Ref = database.child('users').child(userid1!);
  final user1ActiveChats = <String>{};
  final user1ActiveChatsSnapshot = await user1Ref.child('activechats').once();
  final user1ActiveChatsMap =
      user1ActiveChatsSnapshot.snapshot.value as Map<String, dynamic>?;

  final recieversActiveChats = <Set<String>>{};

  if (user1ActiveChatsMap != null) {
    for (final chats in user1ActiveChatsMap.values) {
      for (var value in chats.values) {
        if (value.runtimeType == String) {
          user1ActiveChats.add(value);
        }
      }
    }
  }

  for (String? recieverid in recieverids) {
    final user2Ref = database.child('users').child(recieverid!);
    final user2ActiveChats = <String>{};
    final user2ActiveChatsSnapshot = await user2Ref.child('activechats').once();
    final user2ActiveChatsMap =
        user2ActiveChatsSnapshot.snapshot.value as Map<String, dynamic>?;
    if (user2ActiveChatsMap != null) {
      for (final chats in user2ActiveChatsMap.values) {
        for (var value in chats.values) {
          if (value.runtimeType == String) {
            user2ActiveChats.add(value);
          }
        }
      }
      recieversActiveChats.add(user2ActiveChats);
    }
  }
  int numberOfUsersInChat = 1 + recieverids.length;

  List<String> sharedChats = [];
  for (Set<String?> reciverActiveChat in recieversActiveChats) {
    sharedChats = user1ActiveChats.intersection(reciverActiveChat).toList();
    print(sharedChats);
    break;
  }
  for (Set<String?> reciverActiveChat in recieversActiveChats) {
    sharedChats = sharedChats.toSet().intersection(reciverActiveChat).toList();
    print(sharedChats);
  }

  if (sharedChats.length >= 1) {
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
//find user's active chats in users db
// get that id and query chats, directmessages db
//find chat, extract users in chat (add it to list) [dont add self to list from users in chat]
//return list
}

Future<List<String>> getUsersActiveChats(String? userid) async {
  final database = FirebaseDatabase.instance.ref();
  final userRef = database.child('users').child(userid!);
  // final activeChatRef = userRef.child('activechats');
  final activeChats = <String>{};
  final userActiveChatSS = await userRef.child('activechats').once();
  final userActiveChatMap =
      userActiveChatSS.snapshot.value as Map<String, dynamic>?;
  if (userActiveChatMap != null) {
    for (final chats in userActiveChatMap.values) {
      for (var value in chats.values) {
        if (value.runtimeType == String) {
          activeChats.add(value);
        }
      }
    }
  }
  // ignore: avoid_print, prefer_interpolation_to_compose_strings
  print("Active chats " + activeChats.toList().toString());
  return activeChats.toList();
}

//get UserIDs
Future<Map<List<String>, String>> getUserActiveChatHelper(
    List<String> activeChats) async {
  final database = FirebaseDatabase.instance.ref();
  final chatRef = database.child('chats/directmessages');
  //key: list of userids, value: chatid
  Map<List<String>, String> map = {};
  //final userIDsChattingWith = <String>{};
  int iterator = 0;

  try {
    for (final activeChatref in activeChats) {
      if (activeChatref != null) {
        final senderUserID = UserInformationSingleton().getFirebaseUser()!.uid;
        final userID = await chatRef.child(activeChatref).once();
        final userIDsHMP = userID.snapshot.value as Map<String, dynamic>?;
        List<String> usersChattingWithList = [];
        for (var idk in userIDsHMP!['usersInChat'].values) {
          //if (idk.values != senderUserID) {
          //At this moment, we are about to print all the users in an active chat.
          //print(idk.values);
          for (var idek in idk.values) {
            if (idek != senderUserID) {
              usersChattingWithList.add(idek);
            }
          }
        }
        map[usersChattingWithList] = activeChats[iterator];
        iterator++;
      }
    }
    print(map);
    return map;
  } catch (e) {
    print("OOPSIE: $e");
    return map;
  }
}

Future<Map<List<String>, String>> getUserEmailMapFromUserIdMap(
    Map<List<String>, String> map) async {
  final database = FirebaseDatabase.instance.ref();
  final databasestuff = database.child('/users');
  Map<List<String>, String> emailMap = {};
  for (List<String> key in map.keys) {
    List<String> emails = [];
    String chatID = "";
    for (String userID in key) {
      final databaseCurrUser = await databasestuff.child(userID).get();
      final email =
          (Map<String, dynamic>.from(databaseCurrUser.value as Map)['fname']);
      emails.add(email);
      chatID = map[key]!;
    }
    emailMap[emails] = chatID;
  }
  print(emailMap);
  return emailMap;
}
