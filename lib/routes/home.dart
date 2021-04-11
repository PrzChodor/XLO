import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavigationIndex = 0;

  void _navigationSelect(int index) {
    setState(() {
      _selectedNavigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        onTap: _navigationSelect,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add),
            label: 'Add Auction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check),
            label: 'Archived',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoPageScaffold(
            child: Center(
                child: CupertinoButton(
          onPressed: () {
            context.read<AuthenticationService>().signOut();
          },
          child: const Text(
            'sign out',
            style: TextStyle(color: CupertinoColors.white),
          ),
          color: CupertinoColors.activeBlue,
        )));
      },
    );
  }
}
