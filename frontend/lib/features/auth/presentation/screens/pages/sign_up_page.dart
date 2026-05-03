import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/screens/mobile_layout/mobile_sign_up_page.dart';
import 'package:frontend/features/auth/presentation/screens/web_layout/web_sign_up_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return (kIsWeb) ? const WebSignUpPage() : const MobileSignUpPage();
  }
}
