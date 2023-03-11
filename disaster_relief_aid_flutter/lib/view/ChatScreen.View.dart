import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CreateProfile.view.dart';

class ChatScreenView extends StatefulWidget {
  final String userEmail;

  const ChatScreenView({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<ChatScreenView> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat with ${widget.userEmail}"),
        ),
        body: const SingleChildScrollView());
  }
}
