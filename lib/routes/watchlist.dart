import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/model/ad.dart';

class Watchlist extends StatefulWidget {

  @override
  _WatchlistState createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  List<Ad> _ads = [];


  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        return CupertinoPageScaffold(
            child: SafeArea(
              child: CupertinoScrollbar(
                child: CustomScrollView(
                  slivers: [
                    CupertinoSliverNavigationBar(
                      largeTitle: Text('Watchlist'),
                    )
                  ],
                ),
              ),
            )
        );
      },
    );
  }
}

// class WatchlistFunctionality{
//   final firebaseUser=FirebaseAuth.instance.currentUser;
//
//   final CollectionReference _watchlistCollection=FirebaseFirestore.instance.collection('watchlist');
//
//
//   List<WatchlistAd> _watchlistAds(QuerySnapshot snapshot) {
//     return snapshot.docs.map<WatchlistAd>((doc) {
//       return WatchlistAd(
//         adID: doc.data()['adID'] ?? '',
//         ownerID: doc.data()['adID'] ?? '',
//         title: doc.data()['adID'] ?? '',
//         description: doc.data()['adID'] ?? '',
//         images: doc.data()['adID'] ?? [],
//         dateTime: doc.data()['adID'] ?? DateTime.now(),
//         email: doc.data()['adID'] ?? '',
//         archived: doc.data()['adID'] ?? true,
//         price: doc.data()['adID'] ?? '',
//         place: doc.data()['adID'] ?? '',
//       );
//     }).toList();
//   }
//
//
//
//
//   Stream<List<WatchlistAd>> get watchlist{
//     return _watchlistCollection.doc(firebaseUser.uid).collection('ad').snapshots().map(_watchlistAds);
//   }
//
//
//
// }
//
