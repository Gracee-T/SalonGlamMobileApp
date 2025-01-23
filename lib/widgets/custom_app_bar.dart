import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:salon_glam/pages/landing_page.dart';
import 'package:salon_glam/pages/view_appointment_page.dart';
import 'package:salon_glam/pages/view_profile_page.dart';
import 'package:salon_glam/services/selected_service_provider.dart';
import 'package:salon_glam/widgets/cart.dart'; // Replace with your landing or welcome page import

// BasePage class which contains the app bar and navigation bar
class BasePage extends StatefulWidget {
  final String title; // Title for the app bar
  final Widget bodyContent; // The body content for the page

  const BasePage({super.key, required this.title, required this.bodyContent});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // Method to handle the logout process
  Future<void> handleLogout(BuildContext context) async {
    try {
      // Sign out the user from Firebase
      await FirebaseAuth.instance.signOut();

      // Navigate to the landing or welcome screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const WelcomeScreen(), // Replace with your landing page widget
        ),
      );

      // Show a snackbar confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Successfully signed out',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show error message if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/background.png', // Replace with the path to your logo
                width: 30, // Adjust the size of the logo
                height: 30,
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Salon Glam', // Corrected from "Glem" to "Glam"
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProfilePage(), // Navigate to ProfilePage
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ViewAppointmentPage(), // Navigate to ProfilePage
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.bodyContent, // The body content that will vary per page
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(255, 44, 145, 240),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              setState(() {
                currentIndex = index;
              });
              Navigator.pushReplacementNamed(context, '/homePage');
              break;
            case 1:
              setState(() {
                currentIndex = index;
              });
              Navigator.pushReplacementNamed(context, '/servicesPage');
              break;
            case 2:
              setState(() {
                currentIndex = index;
              });
              Navigator.pushReplacementNamed(context, '/reviewsPage');
              break;
            case 3:
              setState(() {
                currentIndex = index;
              });
              handleLogout(context); // Call handleLogout on logout tap
              break;
          }
        },
      ),
      floatingActionButton: Provider.of<SelectedServiceProvider>(context)
              .cartItems
              .isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: Icon(
                      Icons.shopping_cart,
                      size: 25.0,
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Consumer<SelectedServiceProvider>(
                        builder: (context, selectedServiceProvider, child) {
                          return Text(
                            '${selectedServiceProvider.cartItems.length}',
                            style: const TextStyle(
                              height: 0.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
