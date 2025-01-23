import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_glam/firebase_options.dart';
import 'package:salon_glam/pages/home_page.dart';
import 'package:salon_glam/pages/landing_page.dart';
import 'package:salon_glam/routes/routes.dart';
import 'package:salon_glam/services/selected_service_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  _updateEmail(User user) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .update({'email': user.email});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedServiceProvider(),
      child: MaterialApp(
        title: 'Essential Care & Wellness',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // check if user signed in
            if (snapshot.hasData) {
              User user = FirebaseAuth.instance.currentUser!;

              // make sure correct email displayed in profile
              _updateEmail(user);

              return const HomePage();
            } else {
              return const WelcomeScreen();
            }
          },
        ),
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
