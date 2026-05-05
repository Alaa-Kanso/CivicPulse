import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/features/auth/presentation/cubit/log_in_cubit.dart';
import 'package:frontend/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:frontend/features/auth/presentation/screens/pages/log_in_page.dart';
import 'package:frontend/features/auth/presentation/screens/pages/sign_up_page.dart';
import 'package:frontend/features/auth/presentation/screens/pages/welcome_page.dart';

class AuthNav extends StatelessWidget {
  const AuthNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/sign-up":
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (BuildContext context) => sl<SignUpCubit>(),
                child: const SignUpPage(),
              ),
            );
          case "/log-in":
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (BuildContext context) =>sl<LogInCubit>(),
                child: const LogInPage(),
              ),
            );
          default:
            return MaterialPageRoute(builder: (context) => const WelcomePage());
        }
      },
    );
  }
}
