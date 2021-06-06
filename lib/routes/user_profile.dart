import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/routes/ads_active.dart';
import 'package:xlo_auction_app/routes/ads_archived.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  'Welcome,\n' +
                      _auth.getCurrentUserEmail().substring(
                          0, _auth.getCurrentUserEmail().indexOf('@')) +
                      '!',
                  textAlign: TextAlign.start,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle,
                ),
              ),
            ),
            Text(
              'Your advertisements',
              style: CupertinoTheme.of(context)
                  .textTheme
                  .textStyle
                  .merge(TextStyle(fontWeight: FontWeight.bold)),
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
                      CupertinoPageRoute(builder: (context) => AdsActive()));
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
                      CupertinoPageRoute(builder: (context) => AdsArchived()));
                }),
            Text(
              'Settings and information',
              style: CupertinoTheme.of(context)
                  .textTheme
                  .textStyle
                  .merge(TextStyle(fontWeight: FontWeight.bold)),
            ),
            CupertinoButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Settings',
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                    ),
                    Icon(CupertinoIcons.arrow_right,
                        color: CupertinoTheme.of(context).primaryColor),
                  ],
                ),
                onPressed: () {}),
            CupertinoButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Help',
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                    ),
                    Icon(CupertinoIcons.arrow_right,
                        color: CupertinoTheme.of(context).primaryColor),
                  ],
                ),
                onPressed: () {}),
            CupertinoButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Privacy policy',
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                    ),
                    Icon(CupertinoIcons.arrow_right,
                        color: CupertinoTheme.of(context).primaryColor),
                  ],
                ),
                onPressed: () {}),
            CupertinoButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'About app',
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                    ),
                    Icon(CupertinoIcons.arrow_right,
                        color: CupertinoTheme.of(context).primaryColor),
                  ],
                ),
                onPressed: () {}),
            CupertinoButton(
                child: Text(
                  'Sign out',
                  style: CupertinoTheme.of(context).textTheme.actionTextStyle,
                ),
                onPressed: () {
                  _auth.signOut();
                })
          ],
        ),
      ),
    );
  }
}
