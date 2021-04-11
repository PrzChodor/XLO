import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xlo_auction_app/authentication/authenticationError.dart';

class SignIn extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              textScaleFactor: 2,
            ),
            CupertinoTextField(
              controller: emailController,
              placeholder: 'email',
            ),
            CupertinoTextField(
              controller: passwordController,
              placeholder: 'password',
              obscureText: true,
            ),
            CupertinoButton(
              onPressed: () async {
                bool isSignedIn;
                try {
                  isSignedIn = await context
                      .read<AuthenticationService>()
                      .signInWithEmail(
                        context,
                        emailController.text,
                        passwordController.text,
                      );
                } on FirebaseAuthException catch (e) {
                  print(e.message);
                  showAuthenticationErrorDialog(
                    context,
                    e.message,
                  );
                }
                if (isSignedIn == true) {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/');
                }
              },
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
