import 'dart:math';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/model/chat_list_item.dart';
import 'package:xlo_auction_app/model/chat_message.dart';
import 'auction_list.dart';
import 'package:provider/provider.dart';

import 'chat.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final TextEditingController searchController = TextEditingController();
  List<ChatListItem> chats = [];
  var stream;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection('user')
        .doc(AuthenticationService().getCurrentUserId())
        .collection('chats')
        .orderBy('username')
        .get()
        .asStream();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthenticationService>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Chats'),
      ),
      child: SafeArea(
        child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              Center(
                child: CupertinoActivityIndicator(
                  radius: min(MediaQuery.of(context).size.width * 0.1,
                      MediaQuery.of(context).size.height * 0.1),
                ),
              );
            } else {
              chats = snapshot.data.docs
                  .map<ChatListItem>((chat) => ChatListItem(
                      username: chat.data()['username'],
                      message: chat.data()['message'],
                      date: chat.data()['date'],
                      chatID: chat.id))
                  .toList();
            }

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return Card(
                  color: CupertinoTheme.of(context).barBackgroundColor,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0.0,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Chat(
                          senderUsername: _auth.getCurrentUserEmail().substring(
                              0, _auth.getCurrentUserEmail().indexOf('@')),
                          receiverUsername: chats[index].username,
                          sender: _auth.getCurrentUserId(),
                          receiver: chats[index].chatID,
                        ),
                      ),
                    ),
                    child: chats[index],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
