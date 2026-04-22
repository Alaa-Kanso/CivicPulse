import 'package:flutter/material.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/PageComponent/welcome_page_component.dart';

class WebWelcomePage extends StatefulWidget {
  const WebWelcomePage({super.key});

  @override
  State<WebWelcomePage> createState() => _WebWelcomePageState();
}

class _WebWelcomePageState extends State<WebWelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeWebHeader(),
            const SizedBox(height: 30),
            const WelcomeWebBodyTop(),
            const SizedBox(height: 20),
            const WelcomeWebBodyFeatures(),
            const SizedBox(height: 30),
            const WelcomeWebBodyWorks(),
            const WelcomeWebFooter(),
          ],
        ),
      ),
    );
  }
}
