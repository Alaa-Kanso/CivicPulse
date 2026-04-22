import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/Cubit/AuthCubit/auth_cubit.dart';
import 'package:frontend/gates.dart';

void main() {
  runApp(
    BlocProvider(
      create: (BuildContext context) => AuthCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,home: SafeArea(child: AuthGate()));
  }
}
