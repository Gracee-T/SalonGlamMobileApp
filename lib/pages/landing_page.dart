import 'package:flutter/material.dart';
import 'package:salon_glam/pages/login_page.dart';
import 'package:salon_glam/pages/registration_page.dart';
import 'package:salon_glam/widgets/custom_scaffold.dart';
import 'package:salon_glam/widgets/landing_button.dart';
import 'package:salon_glam/widgets/theme/custom_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Essential Care &\n \t Wellness',
                            style: TextStyle(
                                fontSize: 45.0,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 244, 213, 154))),
                        TextSpan(
                            text:
                                '\nYour beauty is our Priority\n Elevate your style',
                            style: TextStyle(
                                fontSize: 20,
                                // height: 0,
                                color: Color.fromARGB(255, 255, 213, 96)))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SignInScreen(),
                      color: Color.fromARGB(0, 255, 255, 255),
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.white,
                      textColor: lightColorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
