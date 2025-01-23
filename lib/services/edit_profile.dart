import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  final String field;
  final String currentValue;

  const EditProfile(
      {super.key, required this.field, required this.currentValue});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _controller = TextEditingController();

  Map fields = {
    "fullName": "Full Name",
    "email": "Email",
    "phone": "Phone Number",
  };

  @override
  void initState() {
    super.initState();
    _controller.text = widget.currentValue; // Initialize the text controller
  }

  Future<void> _saveChanges() async {
    if (_controller.text.trim().isNotEmpty) {
      if (widget.field == 'email') {
        FirebaseAuth.instance.currentUser!
            .verifyBeforeUpdateEmail(_controller.text.trim());

        // Update Firestore with new value
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          widget.field: _controller.text.trim(),
        });

        // Show success message and go back to profile page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Check your \'${_controller.text.trim()}\' inbox verify your new email.')),
        );
      } else {
        // Update Firestore with new value
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          widget.field: _controller.text.trim(),
        });

        // Show success message and go back to profile page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
      Navigator.of(context).pop();
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
      title: Text('Edit ${fields[widget.field]}'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter new ${widget.field}',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveChanges,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
