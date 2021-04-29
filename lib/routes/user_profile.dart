import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';

class UserProfile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _UserProfile();

}

class _UserProfile extends State<UserProfile>{
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationService>(context);

    return Container(
        child: CupertinoButton(
          onPressed: () {
            auth.signOut();
          },
          child: const Text(
            'Tutaj bedzie user profile',
            style: TextStyle(color: CupertinoColors.white),
          ),
          color: CupertinoColors.activeBlue,
        ));
  }
}