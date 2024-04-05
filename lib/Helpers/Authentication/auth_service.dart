import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Routes/login.dart';
import '../../Helpers/Widgets/standard_widgets.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> registration({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message!;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  void logout(BuildContext context) async {
    _auth.signOut().then((value) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const NoticeDialog(content: 'Logout failed');
            });
      }
    });
  }
}
