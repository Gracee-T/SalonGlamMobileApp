import 'package:flutter/material.dart';
import 'package:salon_glam/models/hairstyle_model.dart';
import 'package:salon_glam/pages/appointment_page.dart';
import 'package:salon_glam/pages/haircut_page.dart';
import 'package:salon_glam/pages/hairstyle_page.dart';
import 'package:salon_glam/pages/home_page.dart';
import 'package:salon_glam/pages/landing_page.dart';
import 'package:salon_glam/pages/login_page.dart';
import 'package:salon_glam/pages/makeup_page.dart';
import 'package:salon_glam/pages/nail_page.dart';
import 'package:salon_glam/pages/registration_page.dart';
import 'package:salon_glam/pages/reviews_page.dart';
import 'package:salon_glam/pages/services_page.dart';

class RouteManager {
  static const String landingPage = '/'; // Route for landing page
  static const String loginPage =
      '/login'; // Route for client login page (duplicate)
  static const String signUpPage =
      '/signUpPage'; // Route for client signup page
  static const String homePage = '/homePage'; // Route for client home page
  static const String servicesPage =
      '/servicesPage'; // Route for client service page
  static const String reviewsPage =
      '/reviewsPage'; // Route for client review page
  static const String appointmentPage = '/appointment';
  static const String hairStylePage = '/hairStylePage';
  static const String haircutPage = '/hairCutPage';
  static const String makeUpPage = '/makeUpPage';
  static const String nailsPage = '/nailsPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landingPage:
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(), // Load login page
        );
      case homePage:
        return MaterialPageRoute(
          builder: (context) => const HomePage(), // Load login page
        );
      case hairStylePage:
        return MaterialPageRoute(
          builder: (context) => const HairstylePage(), // Load login page
        );
      case haircutPage:
        return MaterialPageRoute(
          builder: (context) => const HaircutPage(), // Load login page
        );
      case makeUpPage:
        return MaterialPageRoute(
          builder: (context) => const MakeupPage(), // Load login page
        );
      case nailsPage:
        return MaterialPageRoute(
          builder: (context) => const NailsPage(), // Load login page
        );
      case loginPage:
        return MaterialPageRoute(
          builder: (context) =>
              const SignInScreen(), // Load book appointments page
        );

      case signUpPage:
        return MaterialPageRoute(
          builder: (context) =>
              const SignUpScreen(), // Load book appointments page
        );

      case reviewsPage:
        return MaterialPageRoute(
          builder: (context) =>
              const FeedbackPage(), // Load book appointments page
        );
      case appointmentPage:
        return MaterialPageRoute(
          builder: (context) => BookAppointmentsPages(
            selectedService: Hairstyle(
                id: "asd",
                name: "hair",
                imagePath:
                    "https://firebasestorage.googleapis.com/v0/b/glam-478d7.appspot.com/o/IMG-20240928-WA0053.jpg?alt=media",
                price: 40),
          ), // Link to AppointmentPage class
        );
      case servicesPage:
        return MaterialPageRoute(
          builder: (context) =>
              const ServicesPage(), // Link to AppointmentPage class
        );

      default:
        throw const FormatException(
            'Page does not exist.'); // Throw exception if page does not exist
    }
  }
}
