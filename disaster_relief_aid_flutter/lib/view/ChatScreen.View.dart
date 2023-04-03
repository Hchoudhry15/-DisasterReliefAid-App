import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../component/ChatBubble.component.dart';
import '../model/message.model.dart';
import '../singletons/UserInformation.dart';
import 'package:profanity_filter/profanity_filter.dart';

class ChatScreenView extends StatefulWidget {
  final String uid;
  final List<String?> recieverids;
  final String chatid;
  final String recieverEmail;
  final String senderEmail;
  final Map<String, String> uIDToEmailMap;

  const ChatScreenView(
      {Key? key,
      required this.uid,
      required this.recieverids,
      required this.chatid,
      required this.recieverEmail,
      required this.senderEmail,
      required this.uIDToEmailMap})
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
  Stream<DataSnapshot> emailStream = const Stream.empty();

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
          widget.chatid, widget.uid, widget.recieverids, _textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.recieverEmail}"),
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
                          if (message['senderid'] ==
                              UserInformationSingleton()
                                  .getFirebaseUser()!
                                  .uid) {
                            isCurrentUser = true;
                          } else {
                            isCurrentUser = false;
                          }
                          return ChatBubble(
                              text: message['messageDetails'],
                              isCurrentUser: isCurrentUser,
                              senderEmail:
                                  widget.uIDToEmailMap[message['senderid']]!);
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

Future addMessageToDB(String chatid, String uid, List<String?> recieveruids,
    String messageDetails) async {
  try {
    final database = FirebaseDatabase.instance.ref();
    final messageRef =
        database.child('/chats/directmessages').child(chatid).child('messages');
    final newMessageKey = messageRef.push().key;
    final newMessage = messageRef.child(newMessageKey!);
    final filter = ProfanityFilter();

    for (String? recieveruid in recieveruids) {
      await newMessage.set(
        {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'messageDetails': filter.censor(messageDetails),
          'senderid': uid,
          'recieveruid': recieveruid,
        },
      );
    }
    print("worked");
  } catch (e) {
    print("Messages: An error has occured");
    print(e);
  }
}
