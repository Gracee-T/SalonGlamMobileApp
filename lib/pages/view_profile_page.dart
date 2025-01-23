import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salon_glam/models/user_model.dart'; // Import the UserProfile model
import 'package:salon_glam/services/edit_profile.dart';
import 'package:salon_glam/services/reauthenticate.dart';
import 'package:salon_glam/widgets/custom_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'Profile', // Title for the app bar
      bodyContent: _ProfileBody(), // Body content as a separate widget
    );
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: usersCollection.doc(currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('User profile does not exist.'));
        }

        // Safely cast the data to a Map
        final userDataMap = snapshot.data!.data() as Map<String, dynamic>?;

        if (userDataMap == null) {
          return const Center(child: Text('User profile does not exist.'));
        }

        // Use the UserProfile model to parse the data
        final userData = UserProfile.fromMap(userDataMap);

        return Column(
          // padding: const EdgeInsets.all(10.0),
          children: [
            const Icon(Icons.person, size: 100, color: Colors.green),
            Text(
              currentUser.email!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 50),
            buildRow('Full Name', userData.fullName!),
            buildRow('Email', userData.userEmail!),
            buildRow('Phone Number', userData.phoneNumber!),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Map fields = {
    "Full Name": "fullName",
    "Email": "email",
    "Phone Number": "phone"
  };

  Widget buildRow(String field, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => field != 'Email'
                          ? EditProfile(
                              field: fields[field], currentValue: value)
                          : Reauthenticate(
                              field: fields[field], currentValue: value),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
