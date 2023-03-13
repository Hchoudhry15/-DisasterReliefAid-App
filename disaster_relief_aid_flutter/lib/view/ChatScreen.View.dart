import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../component/ChatBubble.component.dart';
import '../model/message.model.dart';
import '../singletons/UserInformation.dart';

class ChatScreenView extends StatefulWidget {
  final String uid;
  final String recieverid;
  final String chatid;

  const ChatScreenView(
      {Key? key,
      required this.uid,
      required this.recieverid,
      required this.chatid})
      : super(key: key);

  @override
  State<ChatScreenView> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenView> {
  final database = FirebaseDatabase.instance.ref();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  String? currentChat;

  Stream<DataSnapshot> messageStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    messageStream = database
        .child('/chats/directmessages/')
        .child(widget.chatid)
        .child('messages')
        .orderByChild('timestamp')
        .onValue
        .map((event) => event.snapshot);
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      addMessageToDB(
          widget.chatid, widget.uid, widget.recieverid, _textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.uid}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StreamBuilder<DataSnapshot>(
                  stream: messageStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<DataSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final messages = Map<String, dynamic>.from(
                          snapshot.data!.value as Map);

                      return ListView.builder(
                        reverse: false,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final message = messages.values.elementAt(index);
                          bool isCurrentUser;
                          if (message['recieveruid'] !=
                              UserInformationSingleton()
                                  .getFirebaseUser()!
                                  .uid) {
                            isCurrentUser = true;
                          } else {
                            isCurrentUser = false;
                          }
                          if (message['messageDetails'] == "TEST-MESSAGE") {}
                          return ChatBubble(
                            text: message['messageDetails'],
                            isCurrentUser: isCurrentUser,
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
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

Future addMessageToDB(String chatid, String uid, String recieveruid,
    String messageDetails) async {
  try {
    final database = FirebaseDatabase.instance.ref();
    final messageRef =
        database.child('/chats/directmessages').child(chatid).child('messages');
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
  } catch (e) {
    print("Messages: An error has occured");
    print(e);
  }
}
