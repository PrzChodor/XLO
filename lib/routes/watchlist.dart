import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xlo_auction_app/model/ad.dart';
import 'package:xlo_auction_app/routes/ad_details.dart';
import 'package:xlo_auction_app/widgets/ad_item.dart';

class Watchlist extends StatefulWidget {
  @override
  _WatchlistState createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  List<Ad> _ads = [];

  @override
  void initState() {
    startWatchlist();
    super.initState();
  }

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
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          color: CupertinoTheme.of(context).barBackgroundColor,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0.0,
                          child: InkWell(
                            child: AdItem(
                                _ads[index].images[0],
                                _ads[index].title,
                                _ads[index].dateTime.toDate(),
                                _ads[index].price,
                                _ads[index].place),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute(
                                  builder: (context) => AdDetails(_ads[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      childCount: _ads.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }

  startWatchlist() async {
    _ads.clear();
    final firebaseUser = FirebaseAuth.instance.currentUser;

    String currentUser = firebaseUser.uid;
    var docs = await FirebaseFirestore.instance
        .collection('auctions')
        .where('bookmarkedBy', arrayContains: currentUser)
        .get()
        .then((snapshot) => snapshot.docs);
    _ads = docs
        .map<Ad>((a) => Ad(
            a.id,
            a['ownerID'],
            a['title'],
            a['description'],
            a['images'],
            a['date'],
            a['email'],
            a['archived'],
            a['price'],
            a['place'],
            false,
            a['bookmarkedBy']))
        .toList();
    _ads.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }
}

// class WatchlistFunctionality {
//   final firebaseUser = FirebaseAuth.instance.currentUser;
//
//   final CollectionReference _watchlistCollection =
//       FirebaseFirestore.instance.collection('watchlist');
//
//   List<Ad> _watchlistAds(QuerySnapshot snapshot) {
//     return snapshot.docs.map<Ad>((doc) {
//       return Ad(
//           doc.data()['adID'] ?? '',
//           doc.data()['adID'] ?? '',
//           doc.data()['adID'] ?? '',
//           doc.data()['adID'] ?? '',
//           doc.data()['adID'] ?? [],
//           doc.data()['adID'] ?? DateTime.now(),
//           doc.data()['adID'] ?? '',
//           doc.data()['adID'] ?? true,
//           doc.data()['adID'] ?? '',
//           doc.data()['adID'] ?? '',
//           false,
//           doc.data()['bookmarkedBy']);
//     }).toList();
//   }
//
//   Stream<List<Ad>> get watchlist {
//     return _watchlistCollection
//         .doc(firebaseUser.uid)
//         .collection('ad')
//         .snapshots()
//         .map(_watchlistAds);
//   }
// }
