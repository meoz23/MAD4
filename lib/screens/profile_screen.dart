import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final uid = _auth.currentUser!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();

    _firstNameController.text = doc['firstName'] ?? '';
    _lastNameController.text = doc['lastName'] ?? '';

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    final uid = _auth.currentUser!.uid;

    await _firestore.collection('users').doc(uid).update({
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: const Text('Save Changes'),
                  )
                ],
              ),
            ),
    );
  }
}