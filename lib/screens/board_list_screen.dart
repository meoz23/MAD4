import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class BoardListScreen extends StatelessWidget {
  const BoardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Boards'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('boards').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No boards available.'));
          }

          var boards = snapshot.data!.docs;

          return ListView.builder(
            itemCount: boards.length,
            itemBuilder: (context, index) {
              var board = boards[index];
              String boardName = board['name'];

              return ListTile(
                leading: Icon(Icons.chat_bubble_outline),
                title: Text(boardName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(boardName: boardName),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}