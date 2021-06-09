import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/model/ad.dart';
import 'package:xlo_auction_app/routes/ad_details.dart';
import 'package:xlo_auction_app/widgets/ad_item.dart';
import 'package:xlo_auction_app/widgets/sliver_fill_remaining_box_adapter.dart';

class AdsActive extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdsActiveState();
}

class _AdsActiveState extends State<AdsActive> {
  List<Ad> _ads = [];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthenticationService>();

    return CupertinoPageScaffold(
      child: SafeArea(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text('Active'),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('ads')
                    .where('ownerID', isEqualTo: _auth.getCurrentUserId())
                    .where('archived', isEqualTo: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return SliverFillRemainingBoxAdapter(
                      child: Center(
                        child: CupertinoActivityIndicator(
                          radius: min(MediaQuery.of(context).size.width * 0.1,
                              MediaQuery.of(context).size.height * 0.1),
                        ),
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
                          a['username'],
                          a['archived'],
                          a['price'],
                          a['place'],
                          false,
                          a['bookmarkedBy']))
                      .toList();
                  _ads.sort((a, b) => b.dateTime.compareTo(a.dateTime));

                  return SliverPadding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            color:
                                CupertinoTheme.of(context).barBackgroundColor,
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
                                Navigator.of(context, rootNavigator: true).push(
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
