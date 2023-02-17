import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../model/profile.model.dart';
import '../model/user.model.dart';

// ignore: camel_case_types
class liveChatView extends StatelessWidget {
  const liveChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child:
          Text("inTest", style: TextStyle(fontSize: 12, color: Colors.black)),
    )));
  }

  // Future fetchUser(Profile profile, User user) async {
  //   final credential = await FirebaseChatCore.instance.createUserInFirestore(
  //       const types.User(id: "TXWRpVWSt8dolHZngUnKFCCTnuX2"));
  // }
}
