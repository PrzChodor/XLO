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
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Welcome,\n '+auth.getCurrentUserEmail()+'!',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w500,
              ),
            ),
            Text('Your auctions',
            style: TextStyle(
              fontSize: 20,
                fontWeight: FontWeight.bold
            ),
            ),
            CupertinoButton(child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Active',
                  style: TextStyle(
                      color: CupertinoColors.black,
                  ),
                ),
                Icon(CupertinoIcons.arrow_right,color: CupertinoColors.black),
              ],
            ), onPressed: (){}),

            CupertinoButton(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Completed',
                  style: TextStyle(
                      color: CupertinoColors.black
                  ),
                ),
                Icon(CupertinoIcons.arrow_right,color: CupertinoColors.black),
              ],
            ), onPressed: (){}),

            Text('Settings and information',
              style: TextStyle(
                fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            CupertinoButton(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Settings',
                  style: TextStyle(
                      color: CupertinoColors.black
                  ),
                ),
                Icon(CupertinoIcons.arrow_right,color: CupertinoColors.black),
              ],
            ), onPressed: (){}),

            CupertinoButton(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Help',
                  style: TextStyle(
                      color: CupertinoColors.black
                  ),
                ),
                Icon(CupertinoIcons.arrow_right,color: CupertinoColors.black),
              ],
            ), onPressed: (){}),

            CupertinoButton(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Privacy policy',
                  style: TextStyle(
                      color: CupertinoColors.black
                  ),
                ),
                Icon(CupertinoIcons.arrow_right,color: CupertinoColors.black),
              ],
            ), onPressed: (){}),

            CupertinoButton(child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('About app',
                  style: TextStyle(
                  color: CupertinoColors.black
                  ),
                ),
                Icon(CupertinoIcons.arrow_right,color: CupertinoColors.black),
              ],
            ),
                onPressed: (){}
                ),
            CupertinoButton(
                child: const Text('Sign out',
                  style: TextStyle(color: CupertinoColors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
                onPressed: (){
                  auth.signOut();
            })
          ],
        ),
      ),
    );
    // final auth = Provider.of<AuthenticationService>(context);
    // return Container(
    //     child: CupertinoButton(
    //       onPressed: () {
    //         auth.signOut();
    //       },
    //       child: const Text(
    //         'Tutaj bedzie user profile',
    //         style: TextStyle(color: CupertinoColors.white),
    //       ),
    //       color: CupertinoColors.activeBlue,
    //     ));
  }
}