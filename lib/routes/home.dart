import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xlo_auction_app/routes/watchlist.dart';
import 'package:xlo_auction_app/routes/ad_list.dart';
import 'package:xlo_auction_app/routes/new_ad.dart';
import 'package:xlo_auction_app/routes/user_profile.dart';

import 'chat_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    AdList(),
    Watchlist(),
    NewAd(),
    ChatList(),
    UserProfile()
  ];

  final CupertinoTabController _tabController = CupertinoTabController();
  int previous = 0;

  @override
  void initState() {
    _tabController.addListener(() {
      if (_tabController.index == 2) {
        Navigator.of(context, rootNavigator: true)
            .push(CupertinoPageRoute(builder: (context) => NewAd()));
        _tabController.index = previous;
      }
      if (_tabController.index != previous) {
        FocusScope.of(context).unfocus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: 'Watchlist',
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
        if (index == 2) {
          return _pages[previous];
        }
        if (_tabController.index != 2) {
          previous = _tabController.index;
        }
        return _pages[index];
      },
    );
  }
}
