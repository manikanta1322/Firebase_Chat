import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatapp.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.url});
  final url;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 1, // Replace with the actual number of chats
              itemBuilder: (context, index) {
                return ChatListItem(
                  url: widget.url,
                ); // Create ChatListItem widget
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, this.url});
  final url;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        // User avatar here
        backgroundColor: Colors.blue,
        backgroundImage: FileImage(url),
      ),
      title: Text('User Name'), // Replace with the actual user's name
      subtitle: Text('Last message'), // Replace with the last message
      trailing: Text('Time'), // Replace with the timestamp
      onTap: () {
        // Navigate to the chat screen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreens(
                    url: url,
                  )),
        );
      },
    );
  }
}
