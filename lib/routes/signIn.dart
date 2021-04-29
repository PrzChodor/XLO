import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xlo_auction_app/widgets/notification.dart';

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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Login',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navLargeTitleTextStyle),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: CupertinoTextField(
                      controller: emailController,
                      placeholder: 'E-mail',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: CupertinoTextField(
                      controller: passwordController,
                      placeholder: 'Password',
                      obscureText: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton.filled(
                    onPressed: () => _signInWithEmail(context),
                    child: const Text('Sign in'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account yet? ",
                      style: TextStyle(
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .color,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: CupertinoTheme.of(context).primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(
                                  context,
                                  '/register',
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Divider(
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .color,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "OR",
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .merge(TextStyle(fontSize: 12)),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Divider(
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .color,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => _signInWithFacebook(context),
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Image(
                            image: AssetImage('assets/facebook.png'),
                            width: 48,
                            height: 48,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => _signInWithGoogle(context),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CupertinoColors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              image: AssetImage('assets/google.png'),
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle(BuildContext context) async {
    bool isSignedIn;
    final authentication = context.read<AuthenticationService>();
    try {
      isSignedIn = await authentication.signInWithGoogle(context: context);
    } on FirebaseAuthException catch (e) {
      showNotification(
        context,
        'Error',
        e.message,
      );
    }
    if (isSignedIn) Navigator.pushNamed(context, '/');
  }

  void _signInWithFacebook(BuildContext context) async {
    bool isSignedIn;
    final authentication = context.read<AuthenticationService>();
    try {
      isSignedIn = await authentication.signInWithFacebook(context: context);
    } on FirebaseAuthException catch (e) {
      showNotification(
        context,
        'Error',
        e.message,
      );
    }
    if (isSignedIn) Navigator.pushNamed(context, '/');
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
    if (isSignedIn) {
      Navigator.pushNamed(context, '/');
      if (!authentication.isEmailVerified) {
        showNotification(context, 'Verify email', 'Verify email');
      }
    }
  }
}
