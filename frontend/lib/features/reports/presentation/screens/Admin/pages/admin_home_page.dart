import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(10.0),
        child: Row(
          children: [
            Container(
              width: 250,
              color: Colors.grey.shade900,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _navItem(
                    title: "Operators",
                    index: 0,
                    icon: Icons.person_outline,
                  ),
                ],
              ),
            ),
            Expanded(child: Column()),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.white),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.blue : Colors.white),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}
