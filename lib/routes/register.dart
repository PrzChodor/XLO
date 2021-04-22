import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/authentication/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Register',
                textScaleFactor: 2,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: CupertinoTextField(
                controller: emailController,
                placeholder: 'E-Mail',
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: CupertinoTextField(
                controller: passwordController,
                placeholder: 'Password',
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton.filled(
                onPressed: () => _createUserWithEmail(context),
                child: const Text('Register'),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(
                  color: CupertinoColors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(
                      color: CupertinoColors.activeBlue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushNamed(
                            context,
                            '/signIn',
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createUserWithEmail(BuildContext context) async {
    try {
      await context.read<AuthenticationService>().createUserWithEmail(
            context,
            emailController.text,
            passwordController.text,
          );
    } on FirebaseAuthException catch (e) {
      showNotification(
        context,
        'Error',
        e.message,
      );
    }
  }
}
