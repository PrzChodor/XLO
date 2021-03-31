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
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthenticationService>().signOut();
          },
          child: Text('sign out'),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem> [
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
        currentIndex: _selectedNavigationIndex,
        selectedItemColor: Color.fromARGB(200, 255, 0, 0),
        onTap: _navigationSelect,
      ),
    );
  }
}
