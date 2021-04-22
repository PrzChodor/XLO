import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xlo_auction_app/authentication/notification.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
                'Login',
                textScaleFactor: 2,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: CupertinoTextField(
                controller: emailController,
                placeholder: 'E-mail',
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
                onPressed: () => _signInWithEmail(context),
                child: const Text('Sign in'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signInWithEmail(BuildContext context) async {
    bool isSignedIn;
    final authentication = context.read<AuthenticationService>();

    try {
      isSignedIn = await authentication.signInWithEmail(
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
    if (isSignedIn == true) {
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, '/');
      if (!authentication.isEmailVerified) {
        showNotification(context, 'Verify email', 'Verify email');
      }
    }
  }
}
