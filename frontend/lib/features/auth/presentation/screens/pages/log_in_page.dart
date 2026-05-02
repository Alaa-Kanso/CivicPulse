import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/screens/mobile_layout/mobile_log_in_page.dart';
import 'package:frontend/features/auth/presentation/screens/web_layout/web_log_in_page.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return (kIsWeb) ? const WebLogInPage() : const MobileLogInPage();
  }
}
