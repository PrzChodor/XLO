import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/routes/ads_active.dart';
import 'package:xlo_auction_app/routes/ads_archived.dart';
import 'package:xlo_auction_app/widgets/passwordConfirmPopup.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthenticationService>(context);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 0.8 * MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      'Welcome,\n${_auth.getCurrentUsername()}!',
                      textAlign: TextAlign.start,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navLargeTitleTextStyle,
                    ),
                  ),
                ),
                Text(
                  'Your advertisements',
                  style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                ),
                CupertinoButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Active',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                        Icon(CupertinoIcons.arrow_right,
                            color: CupertinoTheme.of(context).primaryColor),
                      ],
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                              builder: (context) => AdsActive()));
                    }),
                CupertinoButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Archived',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                        Icon(CupertinoIcons.arrow_right,
                            color: CupertinoTheme.of(context).primaryColor),
                      ],
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                              builder: (context) => AdsArchived()));
                    }),
                Text(
                  'Settings and information',
                  style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                ),
                CupertinoButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Delete account',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                        Icon(CupertinoIcons.arrow_right,
                            color: CupertinoTheme.of(context).primaryColor),
                      ],
                    ),
                    onPressed: () {
                      deleteChats(context);
                    }),
                CupertinoButton(
                    child: Text(
                      'Sign out',
                      style:
                          CupertinoTheme.of(context).textTheme.actionTextStyle,
                    ),
                    onPressed: () {
                      _auth.signOut();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteChats(BuildContext context) async {
    showPasswordPopup(context);
  }
}
