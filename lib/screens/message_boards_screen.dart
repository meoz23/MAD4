import 'package:flutter/material.dart';

class MessageBoardsScreen extends StatelessWidget {
  const MessageBoardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message Boards')),
      body: const Center(
        child: Text("🎉 Welcome to the Message Boards!"),
      ),
    );
  }
}