import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MessageBoardsScreen extends StatelessWidget {
  const MessageBoardsScreen({super.key});

  final List<Map<String, dynamic>> boards = const [
    {'name': 'General Chat', 'icon': Icons.chat_bubble},
    {'name': 'Study Group', 'icon': Icons.school},
    {'name': 'Random', 'icon': Icons.casino},
    {'name': 'Announcements', 'icon': Icons.campaign},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Boards'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Message Boards'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(board['icon'], color: Colors.blue),
              title: Text(
                board['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(boardName: board['name']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}