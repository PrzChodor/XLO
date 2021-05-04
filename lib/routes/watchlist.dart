import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';

class Watchlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationService>(context);

    return Container(
        child: CupertinoButton(
          onPressed: () {
          auth.signOut();
        },
          child: const Text(
          'watchlist',
          style: TextStyle(color: CupertinoColors.white),
          ),
      color: CupertinoColors.activeBlue,
    ));
  }
}
