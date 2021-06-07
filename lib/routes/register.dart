import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/widgets/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  File _currentImage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              CupertinoSliverNavigationBar(
                largeTitle: Text('Sign up'),
              )
            ];
          },
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CupertinoTheme.of(context).primaryColor,
                          ),
                          child: _currentImage != null
                              ? Image.file(
                                  _currentImage,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  CupertinoIcons.person_alt,
                                  size: 180,
                                  color: CupertinoTheme.of(context)
                                      .barBackgroundColor,
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: CupertinoTextField(
                          controller: _usernameController,
                          placeholder: 'Username',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: CupertinoTextField(
                          controller: _emailController,
                          placeholder: 'E-Mail',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: CupertinoTextField(
                          controller: _passwordController,
                          placeholder: 'Password',
                          obscureText: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton.filled(
                        disabledColor:
                            CupertinoTheme.of(context).barBackgroundColor,
                        onPressed: () => _createUserWithEmail(context),
                        child: const Text('Register'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .color,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                color: CupertinoTheme.of(context).primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createUserWithEmail(BuildContext context) async {
    if (!isUserValid()) return;
    try {
      await context.read<AuthenticationService>().createUserWithEmail(
            context,
            _emailController.text,
            _passwordController.text,
            _usernameController.text,
            _currentImage,
          );
    } on FirebaseAuthException catch (e) {
      showNotification(
        context,
        'Error',
        e.message,
      );
    }
  }

  final RegExp _emailRegExp = RegExp(
    r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  bool isEmailValid() {
    return _emailRegExp.hasMatch(_emailController.text);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        setState(() {
          _currentImage = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  bool isUserValid() {
    if (_usernameController.text.isEmpty) {
      showNotification(context, "Error", "Enter username!");
      return false;
    }
    if (!isEmailValid()) {
      showNotification(context, "Error", "Invalid email!");
      return false;
    }
    if (_passwordController.text.isEmpty) {
      showNotification(context, "Error", "Enter password!");
      return false;
    }
    return true;
  }
}
