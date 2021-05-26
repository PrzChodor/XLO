import 'dart:math';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xlo_auction_app/model/ad.dart';
import 'package:xlo_auction_app/routes/ad_details.dart';
import 'package:xlo_auction_app/widgets/ad_item.dart';

class AdList extends StatefulWidget {
  @override
  _AdListState createState() => _AdListState();
}

class _AdListState extends State<AdList> {
  List<Ad> _ads = [];
  Search currentSearch;
  bool _searching = false;
  String prev = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    searchController.addListener(() {
      if (searchController.text != prev) {
        currentSearch?.cancel();
        currentSearch = Search();
        startSearch(currentSearch);
        prev = searchController.text;
      }
    });
    currentSearch = Search();
    startSearch(currentSearch);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                    largeTitle: Text("Advertisements"),
                  ),
                  SliverPersistentHeader(
                    delegate: SilverSearchBarDelegate(
                        child: SearchBar(searchController)),
                    pinned: true,
                    floating: false,
                  ),
                  _searching
                      ? SliverFillRemaining(
                          child: Center(
                            child: CupertinoActivityIndicator(
                              radius: min(
                                  MediaQuery.of(context).size.width * 0.1,
                                  MediaQuery.of(context).size.height * 0.1),
                            ),
                          ),
                        )
                      : _ads.isEmpty
                          ? SliverFillRemaining(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.sentiment_dissatisfied_outlined,
                                      size: 128,
                                      color: CupertinoTheme.of(context)
                                          .textTheme
                                          .navLargeTitleTextStyle
                                          .color
                                          .withOpacity(0.2),
                                    ),
                                    Text(
                                      'No results',
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .navLargeTitleTextStyle
                                          .merge(TextStyle(
                                              color: CupertinoTheme.of(context)
                                                  .textTheme
                                                  .navLargeTitleTextStyle
                                                  .color
                                                  .withOpacity(0.2))),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SliverPadding(
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
                                          Navigator.of(context,
                                                  rootNavigator: true)
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
            ),
          ),
        );
      },
    );
  }

  void startSearch(Search search) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (search.isCancelled()) return;

    _ads.clear();
    List<String> results = [];

    setState(() {
      _searching = true;
    });

    Algolia algolia = Algolia.init(
      applicationId: 'NLFY2U8IFV',
      apiKey: '4a04acd1a08d627e779699706005df55',
    );

    AlgoliaQuery query = algolia.instance.index('auctions');
    query = query
        .query(searchController.text)
        .filters('archived:false')
        .setHitsPerPage(10)
        .setPage(0);

    (await query.getObjects()).hits.forEach((element) {
      results.add(element.data['objectID']);
    });
    if (search.isCancelled()) return;

    if (results.isNotEmpty) {
      var docs = await FirebaseFirestore.instance
          .collection('auctions')
          .where('__name__', whereIn: results)
          .get()
          .then((snapshot) => snapshot.docs);
      if (search.isCancelled()) return;

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
    setState(() {
      _searching = false;
    });
  }
}

class SilverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const SilverSearchBarDelegate({@required this.child, this.height = 52});

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

class SearchBar extends StatefulWidget {
  final TextEditingController searchController;

  SearchBar(this.searchController);

  @override
  State<StatefulWidget> createState() => _SearchBar();
}

class _SearchBar extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(8),
      child: CupertinoSearchTextField(
        prefixInsets: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
        suffixInsets: EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
        controller: widget.searchController,
      ),
    );
  }
}

class Search {
  bool _cancelled = false;

  void cancel() {
    _cancelled = true;
  }

  bool isCancelled() {
    return this._cancelled;
  }
}
