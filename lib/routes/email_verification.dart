import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/routes/home.dart';
import 'package:xlo_auction_app/widgets/sliver_fill_remaining_box_adapter.dart';

class EmailVerification extends StatefulWidget {
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  Timer refreshTimer = Timer(Duration.zero, () {});
  bool verified = FirebaseAuth.instance.currentUser.emailVerified;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (!verified) waitForVerification();
    super.initState();
  }

  @override
  void dispose() {
    refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return verified
        ? HomePage()
        : CupertinoPageScaffold(
            child: SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  CupertinoSliverNavigationBar(
                    largeTitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Verify Email'),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            child: Icon(
                              CupertinoIcons.square_arrow_right,
                              color: CupertinoTheme.of(context).primaryColor,
                            ),
                            onTap: () => AuthenticationService().signOut(),
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverFillRemainingBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'We sent email to\n',
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .navLargeTitleTextStyle
                                    .merge(TextStyle(
                                      fontSize: 26,
                                    )),
                                children: [
                                  TextSpan(
                                    text: AuthenticationService()
                                        .getCurrentUserEmail(),
                                    style: TextStyle(
                                        color: CupertinoTheme.of(context)
                                            .primaryColor),
                                  ),
                                  TextSpan(
                                    text:
                                        '\n\nClick the link in that email to complete your registration\n\n',
                                  ),
                                  TextSpan(
                                    text: "Can't find the email?",
                                    style: TextStyle(
                                        color: CupertinoTheme.of(context)
                                            .primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: CupertinoButton.filled(
                                child: Text('Resend email'),
                                onPressed: () => FirebaseAuth
                                    .instance.currentUser
                                    .sendEmailVerification(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void waitForVerification() {
    refreshTimer = Timer.periodic(
        Duration(seconds: 5), (timer) => checkVerification(timer));
  }

  Future<void> checkVerification(Timer timer) async {
    await FirebaseAuth.instance.currentUser.reload();
    if (!FirebaseAuth.instance.currentUser.emailVerified) return;
    timer.cancel();
    setState(() {
      verified = true;
    });
  }
}
