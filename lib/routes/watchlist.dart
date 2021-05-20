import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({Key key}) : super(key: key);

  @override
  _WatchlistState createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context){
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
