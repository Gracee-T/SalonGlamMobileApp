import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        userCredential.user!.updateDisplayName(fullName);
        await saveUserToFirestore(
          fullName: fullName,
          email: email,
          phone: phone,
          user: userCredential.user!,
          userType: 'Client',
        );
      }

      return userCredential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //this will save the details inputted by the user to firestore.
  saveUserToFirestore({
    required String fullName,
    required String email,
    required String phone,
    required User user,
    required String userType,
  }) async {
    await _firestore.collection('Users').doc(user.uid).set({
      'fullName': fullName,
      'email': email,
      'userId': user.uid,
      'phone': phone,
      'userType': userType,
    });
  }
}
