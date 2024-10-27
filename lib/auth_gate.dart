// AuthGate will determine whether to show the login screen of the home screen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webapp/auth.dart';
import 'package:provider/provider.dart';
import 'package:webapp/pages/home_page.dart';
import 'package:webapp/pages/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth?>(
      builder: (context, auth, _) {
        return StreamBuilder<User?>(
          stream: auth?.authStateChanges,
          builder: (context, snapshot) {
            // Show loading indicator while waiting for initial connection
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Handle errors
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Something went wrong\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          auth?.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // If we have user data, they're logged in
            if (snapshot.hasData && auth!.validState) {
              print("home page called from auth gate");
              return const HomePage();
            }

            // Otherwise, they need to log in
            print(
                "login page called from auth gate with emailstate: ${auth?.validState}");
            return LoginPage();
          },
        );
      },
    );
  }
}
