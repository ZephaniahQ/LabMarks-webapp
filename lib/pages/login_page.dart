import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/auth.dart';
import 'package:webapp/widgets/nav_bar.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return Scaffold(
      appBar: const UniversalNavBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Spacer(),
            if (!auth.validState)
              const Text(
                "Please login with pucit email!",
                style: TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () async {
                await auth.signInWithGoogle();
              },
              child: const Text('Sign in with Google'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
