// auth.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends ChangeNotifier {
  static final Auth _instance = Auth._internal();

  factory Auth() => _instance;

  Auth._internal() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      // Reset validState when user changes
      if (user == null) {
        validState = true;
      } else {
        validState = _isValidEmail(user.email);
      }
      notifyListeners();
    });
  }

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? "248957554858-3nsm97tu6cnm7ubjmfs2eian5mmpp6m9.apps.googleusercontent.com"
        : null,
  );

  User? _user;
  bool _isLoading = false;
  bool validState = true;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      _setLoading(true);

      UserCredential? userCredential;
      if (kIsWeb) {
        // Web-specific sign in
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        // Mobile sign in
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      // Update validState based on the new user's email
      validState = _isValidEmail(userCredential?.user?.email);
      notifyListeners();

      return userCredential;
    } catch (e) {
      debugPrint('Error Signing in with Google: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  bool _isValidEmail(String? email) {
    if (email == null) return false;
    return email.endsWith('@pucit.edu.pk');
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      // Reset validState after signing out
      validState = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  void notifyListeners() {
    if (kDebugMode) {
      print(
          'Auth state changed: ${user?.displayName} (validState: $validState)');
    }
    super.notifyListeners();
  }
}
