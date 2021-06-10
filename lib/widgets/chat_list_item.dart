import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/model/date_formatter.dart';

class ChatListItem extends StatefulWidget {
  final String username;
  final String message;
  final Timestamp date;
  final String chatID;

  ChatListItem({this.username, this.message, this.date, this.chatID});

  @override
  _ChatListItemState createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  String _photoUrl = '';

  @override
  void initState() {
    AuthenticationService()
        .getUserPhoto(widget.chatID)
        .then((value) => setState(() {
              _photoUrl = value;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoTheme.of(context).primaryColor,
              ),
              width: 48,
              height: 48,
              child: _photoUrl.isNotEmpty
                  ? Image.network(
                      _photoUrl,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      CupertinoIcons.person_fill,
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      size: 32,
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.username,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle
                              .merge(TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Text(
                        DateFormatter.convertTimestampToDate(widget.date),
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .actionTextStyle
                            .merge(TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          CupertinoIcons.chevron_right,
                          size: 16,
                          color: CupertinoTheme.of(context)
                              .textTheme
                              .actionTextStyle
                              .color,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.message + '\n',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .tabLabelTextStyle
                            .merge(
                              TextStyle(fontSize: 15),
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
