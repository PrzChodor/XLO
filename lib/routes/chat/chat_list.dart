import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/model/chat_list_item.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/widgets/sliver_fill_remaining_box_adapter.dart';
import 'package:xlo_auction_app/routes/chat/chat.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<ChatListItem> chats = [];

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthenticationService>();
    final ScrollController _scrollController = ScrollController();

    return CupertinoPageScaffold(
      child: SafeArea(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text('Chat'),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(AuthenticationService().getCurrentUserId())
                    .collection('chats')
                    .orderBy('date', descending: true)
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

                  chats = snapshot.data.docs
                      .map<ChatListItem>((chat) => ChatListItem(
                          username: chat.data()['username'],
                          message: chat.data()['message'],
                          date: chat.data()['date'],
                          chatID: chat.id))
                      .toList();

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final int itemIndex = index ~/ 2;
                        if (index.isEven) {
                          return Card(
                            margin: EdgeInsets.zero,
                            color:
                                CupertinoTheme.of(context).barBackgroundColor,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            elevation: 0.0,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Chat(
                                    senderUsername: _auth.getCurrentUsername(),
                                    receiverUsername: chats[itemIndex].username,
                                    sender: _auth.getCurrentUserId(),
                                    receiver: chats[itemIndex].chatID,
                                  ),
                                ),
                              ),
                              child: chats[itemIndex],
                            ),
                          );
                        }
                        return Container(
                          color: CupertinoTheme.of(context).barBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Divider(
                              height: 1,
                              color: CupertinoTheme.of(context)
                                  .textTheme
                                  .tabLabelTextStyle
                                  .color,
                            ),
                          ),
                        );
                      },
                      semanticIndexCallback: (Widget widget, int localIndex) {
                        if (localIndex.isEven) {
                          return localIndex ~/ 2;
                        }
                        return null;
                      },
                      childCount: max(0, chats.length * 2 - 1),
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
