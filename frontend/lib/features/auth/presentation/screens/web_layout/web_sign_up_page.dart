import 'package:flutter/material.dart';
import 'package:CivicPulse/Component/components.dart';

class WebSignUpPage extends StatefulWidget {
  const WebSignUpPage({super.key});

  @override
  State<WebSignUpPage> createState() => _WebSignUpPageState();
}

class _WebSignUpPageState extends State<WebSignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BoldText(
          text: "Sign-up is not available on web. Please use the mobile app.",
          size: 30.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
