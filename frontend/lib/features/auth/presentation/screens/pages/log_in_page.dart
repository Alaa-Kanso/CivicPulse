import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/presentation/cubit/log_in_cubit.dart';
import 'package:frontend/features/auth/presentation/cubit/log_in_state.dart';
import 'package:frontend/features/auth/presentation/screens/mobile_layout/mobile_log_in_page.dart';
import 'package:frontend/features/auth/presentation/screens/web_layout/web_log_in_page.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogInCubit, LogInState>(
      listener: (BuildContext context, LogInState state) {
        if (state is LogInSuccess) {
          context.read<AuthCubit>().checkAuthenticated();
        }
      },
      child: Scaffold(
        body: (kIsWeb) ? const WebLogInPage() : const MobileLogInPage(),
      ),
    );
  }
}
