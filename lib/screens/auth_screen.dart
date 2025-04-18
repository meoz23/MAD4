import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // Set up logger
  final Logger _logger = Logger();

  // Submit form for login/signup
  void _submitAuthForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    try {
      if (_isLogin) {
        // Login
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        _logger.i("User logged in: ${userCredential.user!.uid}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Login Successful")),
        );
      } else {
        // Sign Up
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        _logger.i("User signed up: ${userCredential.user!.uid}");

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': 'user',
          'registration_time': DateTime.now(),
        });

        _logger.i("User data added to Firestore");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Sign Up Successful")),
        );
      }
    } on FirebaseAuthException catch (e) {
      _logger.e("Error during authentication: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "⚠️ Authentication error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (!_isLogin)
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter first name' : null,
                  ),
                if (!_isLogin)
                  const SizedBox(height: 12),
                if (!_isLogin)
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter last name' : null,
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value != null && value.contains('@') ? null : 'Enter valid email',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value != null && value.length >= 6
                      ? null
                      : 'Password must be at least 6 characters',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitAuthForm,
                  child: Text(_isLogin ? 'Login' : 'Sign Up'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin
                      ? "Don't have an account? Sign Up"
                      : "Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}