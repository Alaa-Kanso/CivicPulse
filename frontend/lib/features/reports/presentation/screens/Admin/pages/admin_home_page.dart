import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/features/operator/presentation/cubit/create_operator_cubit.dart';
import 'package:frontend/features/operator/presentation/screens/admin/pages/admin_create_operator_page.dart';
import 'package:frontend/features/reports/presentation/screens/Admin/components/admin_home_page_components.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    BlocProvider(
      create: (BuildContext context) => sl<CreateOperatorCubit>(),
      child: const AdminCreateOperatorPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: (size < 700) ? AppBar() : null,
      drawer: (size < 700)
          ? Drawer(
              child: AdminSideBar(
                selectedIndex: selectedIndex,
                onItemSelected: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      body: Row(
        children: [
          (size >= 700)
              ? AdminSideBar(
                  selectedIndex: selectedIndex,
                  onItemSelected: (int index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                )
              : const SizedBox(),
          Expanded(
            child: IndexedStack(index: selectedIndex, children: pages),
          ),
        ],
      ),
    );
  }
}
