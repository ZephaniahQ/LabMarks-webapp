// universal_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/auth.dart';

class UniversalNavBar extends StatelessWidget implements PreferredSizeWidget {
  static const String title = "Lab Marks Portal";

  const UniversalNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return AppBar(
      title: const Text(
        title,
        style: TextStyle(fontSize: 28),
      ),
      backgroundColor: const Color.fromARGB(255, 111, 191, 228),
      actions: [
        if (auth.user != null)
          IconButton(
              onPressed: () async {
                await auth.signOut();
              },
              icon: const Icon(Icons.logout))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
