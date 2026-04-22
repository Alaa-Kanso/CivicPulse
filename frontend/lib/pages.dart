import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/web_layout/web_welcome_page.dart';

import 'mobile_layout/mobile_welcome_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return (kIsWeb) ? const WebWelcomePage() : const MobileWelcomePage();
  }
}
