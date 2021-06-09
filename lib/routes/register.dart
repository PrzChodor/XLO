import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/widgets/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xlo_auction_app/widgets/sliver_fill_remaining_box_adapter.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with ScreenLoader<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File _currentImage;
  var _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget screen(BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text('Sign up'),
              ),
              SliverFillRemainingBoxAdapter(
                child: Center(
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
                              ),
                              child: _currentImage != null
                                  ? Image.file(
                                      _currentImage,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      CupertinoIcons.person_circle_fill,
                                      size: 200,
                                      color: CupertinoTheme.of(context)
                                          .primaryColor,
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
                              placeholder: 'Password',
                              controller: _passwordController,
                              obscureText: _isPasswordHidden,
                              suffix: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: GestureDetector(
                                  child: Icon(
                                    _isPasswordHidden
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash,
                                    size: 20.0,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isPasswordHidden = !_isPasswordHidden;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoButton.filled(
                            disabledColor:
                                CupertinoTheme.of(context).barBackgroundColor,
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              await this.performFuture(
                                  () => _createUserWithEmail(context));
                            },
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
                                    color:
                                        CupertinoTheme.of(context).primaryColor,
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
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return !isLoading;
      },
    );
  }

  loader() {
    return CupertinoActivityIndicator(
        radius: min(MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.height * 0.1));
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
