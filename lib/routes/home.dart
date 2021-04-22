import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/routes/archive_auction.dart';
import 'package:xlo_auction_app/routes/auction_list.dart';

class HomePage extends StatelessWidget {
  final List<Widget> _pages = [AuctionList(), ArchiveAuction()];

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
                label: 'Auctions',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.archivebox),
                label: 'Archived',
              ),
            ],
          ),
          tabBuilder: (context, index) {
            return _pages[index];
          },
        ));
  }
}
