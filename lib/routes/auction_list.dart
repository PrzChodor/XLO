import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xlo_auction_app/model/auction.dart';
import 'package:xlo_auction_app/routes/add_auction.dart';
import 'package:xlo_auction_app/routes/auction_details.dart';
import 'package:xlo_auction_app/widgets/auction_item.dart';

class AuctionList extends StatefulWidget {
  @override
  _AuctionListState createState() => _AuctionListState();
}

class _AuctionListState extends State<AuctionList> {
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
                  largeTitle: Text("Auctions"),
                ),
                SliverPersistentHeader(
                  delegate: SilverSearchBarDelegate(child: SearchBarAndAdd()),
                  pinned: true,
                  floating: false,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('auctions')
                        .where('archived', isEqualTo: false)
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return SliverFillRemaining(
                          child: Center(
                            child: CupertinoActivityIndicator(
                              radius: min(
                                  MediaQuery.of(context).size.width * 0.1,
                                  MediaQuery.of(context).size.height * 0.1),
                            ),
                          ),
                        );
                      }

                      List<Auction> auctions = snapshot.data.docs
                          .map<Auction>((a) => Auction(
                              a.id,
                              a['ownerID'],
                              a['title'],
                              a['description'],
                              a['images'],
                              a['date'],
                              a['email'],
                              a['archived'],
                              a['price'],
                              a['place']))
                          .toList();

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
                                child: AuctionItem(
                                    auctions[index].images[0],
                                    auctions[index].title,
                                    auctions[index].dateTime.toDate(),
                                    auctions[index].price,
                                    auctions[index].place),
                                onTap: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            AuctionDetails(auctions[index]))),
                              ),
                            ),
                          ),
                          childCount: auctions.length,
                        )),
                      );
                    })
              ],
            ),
          ),
        ));
      },
    );
  }
}

class SilverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const SilverSearchBarDelegate({
    @required this.child,
    this.height = 56,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SilverSearchBarDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;
}

class SearchBarAndAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchBarAndAddState();
}

class _SearchBarAndAddState extends State<SearchBarAndAdd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              child: CupertinoSearchTextField(
            prefixInsets: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
            suffixInsets: EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
          )),
          CupertinoButton(
            onPressed: () => Navigator.push(context,
                CupertinoPageRoute(builder: (context) => AddAuction())),
            child: Icon(CupertinoIcons.add),
          )
        ],
      ),
    );
  }
}
