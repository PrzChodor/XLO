import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlo_auction_app/model/date_formatter.dart';

class ChatListItem extends StatelessWidget {
  final String username;
  final String message;
  final Timestamp date;
  final String chatID;

  ChatListItem({this.username, this.message, this.date, this.chatID});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                    child: Text(username,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .color),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    alignment: Alignment.topLeft,
                  ),
                  Align(
                    child: Text(
                      message,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          color: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .color),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormatter.convertTimestampToDate(date),
                        style: TextStyle(
                            color: CupertinoTheme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
