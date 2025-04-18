import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String boardName;
  const ChatScreen({super.key, required this.boardName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(boardName)),
      body: const Center(
        child: Text('Chat messages will be displayed here.'),
      ),
    );
  }
}