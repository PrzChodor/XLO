import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/model/ad.dart';
import 'package:xlo_auction_app/routes/ad_details.dart';
import 'package:xlo_auction_app/routes/user_profile.dart';
import 'package:xlo_auction_app/widgets/ad_item.dart';

class AdsActive extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdsActiveState();
}

class _AdsActiveState extends State<AdsActive> {
  final PageController galleryController = PageController();
  List<Ad> _ads = [];

  @override
  void dispose() {
    galleryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthenticationService>();

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Active'),
        ),
        child: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ads')
                  .where('ownerID', isEqualTo: _auth.getCurrentUserId())
                  .where('archived', isEqualTo: false)
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
                        a['username'],
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
                                      _ads[index].place),
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
  }
}
