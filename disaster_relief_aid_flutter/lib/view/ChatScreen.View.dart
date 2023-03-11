import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../singletons/UserInformation.dart';

class ChatScreenView extends StatefulWidget {
  final String userEmail;
  //final String reciverUUID;

  const ChatScreenView({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<ChatScreenView> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenView> {
  final database = FirebaseDatabase.instance.ref();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      User? user = UserInformationSingleton().getFirebaseUser();
      addMessageToDB(
          user!.uid, user.email, _textController.text, widget.userEmail);
      _textController.clear();
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.userEmail}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: const [
                    // ignore: todo
                    // TODO: Implement message list display
                  ],
                ),
              ),
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendMessage();
                    // _sendMessage();
                  }
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future addMessageToDB(String uid, String? email, String messageDetails,
    String recieverEmail) async {
  try {
    final database = FirebaseDatabase.instance.ref();
    final messageRef = database.child('/messages/');
    var messageID = const Uuid().v4();
    final messageEntry = messageRef.child(messageID.toString());
    await messageEntry.set(
      {
        'timestamp': DateTime.now().toString(),
        'messageDetails': messageDetails,
        'idFrom': uid,
        'emailFrom': email,
        'recieverEmail': recieverEmail,
      },
    );
    print("worked");
  } catch (e) {
    print("Messages: An error has occured");
    print(e);
  }
}
