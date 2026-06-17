import 'package:CivicPulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:CivicPulse/gates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();
  runApp(
    BlocProvider(
      create: (BuildContext context) => sl<AuthCubit>()..checkAuthenticated(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: AuthGate()),
    );
  }
}
