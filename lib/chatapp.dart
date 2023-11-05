import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreens extends StatefulWidget {
  const ChatScreens({super.key, this.url});
  final url;
  @override
  _ChatScreensState createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  final TextEditingController _textController = TextEditingController();

  sendMessage() async {
    String messageText = _textController.text;
    // String imgurl = widget.url;
    if (messageText.isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'imageurl': widget.url.toString(),
      });
      print('object');

      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          child: CircleAvatar(
            radius: 15,
            backgroundImage: FileImage(widget.url),
          ),
        ),
        title: Column(
          children: [
            Text('Name'),
            Text('Offline'),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final messages = snapshot.data!.docs.reversed;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  final messageData = message.data() as Map<String, dynamic>;
                  final messageText = messageData['text'] ?? '';
                  messageWidgets.add(
                    ListTile(
                      title: Text(messageText),
                    ),
                  );
                }

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage();
                    print(widget.url.toString());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
