import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        return CupertinoPageScaffold(
            child: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('auctions')
                  .where('bookmarkedBy',
                      arrayContains: AuthenticationService().getCurrentUserId())
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CupertinoActivityIndicator(
                      radius: min(MediaQuery.of(context).size.width * 0.1,
                          MediaQuery.of(context).size.height * 0.1),
                    ),
                  );
                }
                _ads = snapshot.data.docs
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

                return CupertinoScrollbar(
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
                                color: CupertinoTheme.of(context)
                                    .barBackgroundColor,
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
                                      _ads[index].place,
                                      _ads[index].adID),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            AdDetails(_ads[index]),
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
                );
              }),
        ));
      },
    );
  }
}
