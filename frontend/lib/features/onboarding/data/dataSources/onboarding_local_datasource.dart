import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDatasource {
  final SharedPreferences prefs;

  OnboardingLocalDatasource({required this.prefs});

  Future<void> setOnboardingSeen() async {
    await prefs.setBool("onboarding_seen", true);
  }

  bool isOnboardingSeen() {
    return prefs.getBool("onboarding_seen") ?? false;
  }
}
