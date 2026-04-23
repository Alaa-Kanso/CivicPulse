import 'package:flutter/material.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/features/auth/presentation/screens/PageComponent/welcome_page_component.dart';

class MobileWelcomePage extends StatefulWidget {
  const MobileWelcomePage({super.key});

  @override
  State<MobileWelcomePage> createState() => _MobileWelcomePageState();
}

class _MobileWelcomePageState extends State<MobileWelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0XFF243f8d),
          image: DecorationImage(
            image: AssetImage("assets/images/welcome_background.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.blue.withOpacity(0.1),
              BlendMode.dstATop,
            ),
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const .all(30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const WelcomeMobileHeader(),
                  const SizedBox(height: 150),
                  ActionButton(
                    text: "Sign Up",
                    textColor: Color(0XFF243f8d),
                    textSize: 20.0,
                    buttonColor: Colors.white,
                    borderColor: Colors.transparent,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  ActionButton(
                    text: "Log In",
                    textColor: Color(0xFFC6CCE0),
                    textSize: 20,
                    buttonColor: Colors.transparent,
                    borderColor: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
