import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon_glam/services/edit_profile.dart';

class Reauthenticate extends StatefulWidget {
  final String field;
  final String currentValue;

  const Reauthenticate(
      {super.key, required this.field, required this.currentValue});

  @override
  _ReauthenticateState createState() => _ReauthenticateState();
}

class _ReauthenticateState extends State<Reauthenticate> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _reauthUser() async {
    User user = _auth.currentUser!;

    if (_controller.text.trim().isNotEmpty) {
      try {
        // Reauthenticate with the user's email and password
        String email = user.email!;

        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: _controller.text,
        );

        await user.reauthenticateWithCredential(credential);

        // After reauthentication, proceed to update the email
        Navigator.of(context).pop();

        showDialog(
          context: context,
          builder: (context) => EditProfile(
              field: widget.field, currentValue: widget.currentValue),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      // Show error message if the input is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a value.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reauthenticate for Email change:'),
      content: TextField(
        controller: _controller,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Enter your Password',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _reauthUser,
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
