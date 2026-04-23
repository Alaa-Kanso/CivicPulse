import 'package:flutter/material.dart';
import 'package:frontend/pages.dart';

class AuthNav extends StatelessWidget {
  const AuthNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          default:
            return MaterialPageRoute(builder: (context) => const WelcomePage());
        }
      },
    );
  }
}
