import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/routes/archive_auction.dart';
import 'package:xlo_auction_app/routes/auction_list.dart';
import 'package:xlo_auction_app/routes/chat.dart';
import 'package:xlo_auction_app/routes/new_auction.dart';
import 'package:xlo_auction_app/routes/user_profile.dart';

class HomePage extends StatelessWidget {
  final List<Widget> _pages = [AuctionList(), ArchiveAuction(), NewAuction(), Chat(), UserProfile()];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<FirebaseFirestore>(
            create: (_) => FirebaseFirestore.instance,
          ),
          Provider<FirebaseStorage>(
            create: (_) => FirebaseStorage.instance,
          ),
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(),
          ),
        ],
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            backgroundColor:
                CupertinoTheme.of(context).barBackgroundColor.withOpacity(1.0),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.list_bullet),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.archivebox),
                label: 'Archived',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.plus_circle),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.profile_circled),
                  label: 'User',
              )
            ],
          ),
          tabBuilder: (context, index) {
            return _pages[index];
          },
        ));
  }
}
