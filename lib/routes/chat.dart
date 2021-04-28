import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/model/chatMessage.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _inputTextController = TextEditingController();
  // final messages = [];
  // lappop
  static const String sender = 'sQqGbK2fJsMdJp2wW5gU6pOguQs2';
  // bartosz
  static const String receiver = '9otfUuuSCrPtgZKmNlpx6bgyXH82';
  int isMessageDateShownIndex = -1;

  @override
  void dispose() {
    _inputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Chat'),
      ),
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .doc(sender)
                .collection(receiver)
                .orderBy('date', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Spacer();
              }

              List<ChatMessage> messages = snapshot.data.docs
                  .map<ChatMessage>((e) =>
                      ChatMessage(e['isSender'], e['message'], e['date']))
                  .toList();

              return Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    index = (index + 1 - messages.length).abs();
                    return Align(
                      alignment: messages[index].isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          if (isMessageDateShownIndex == index) {
                            setState(() {
                              isMessageDateShownIndex = -1;
                            });
                          } else {
                            setState(() {
                              isMessageDateShownIndex = index;
                            });
                          }
                        },
                        child: Column(
                          crossAxisAlignment: messages[index].isSender
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: messages[index].isSender
                                    ? CupertinoTheme.of(context).primaryColor
                                    : CupertinoTheme.of(context)
                                        .barBackgroundColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7),
                              padding: EdgeInsets.all(16),
                              child: Text(
                                messages[index].message,
                                textAlign: TextAlign.start,
                                style: messages[index].isSender
                                    ? CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .merge(TextStyle(
                                            color: CupertinoTheme.of(context)
                                                .barBackgroundColor))
                                    : CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: Visibility(
                                visible: isMessageDateShownIndex == index,
                                child: Text(
                                  convertTimestampToDate(messages[index].date),
                                  style: TextStyle(
                                      color: CupertinoColors.inactiveGray,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            width: double.infinity,
            color: CupertinoTheme.of(context).barBackgroundColor,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                    child: CupertinoTextField(
                      controller: _inputTextController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 6,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CupertinoButton(
                    onPressed: () {
                      addMessage(context);
                      _inputTextController.clear();
                    },
                    child: Icon(
                      CupertinoIcons.arrow_right,
                      size: 26,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addMessage(BuildContext context) async {
    final _firestore = context.read<FirebaseFirestore>();

    DocumentReference _senderChat =
        _firestore.collection('chat').doc(sender).collection(receiver).doc();
    DocumentReference _receiverChat =
        _firestore.collection('chat').doc(receiver).collection(sender).doc();

    var batch = _firestore.batch();
    batch.set(_senderChat, {
      'isSender': true,
      'message': _inputTextController.text,
      'date': DateTime.now()
    });
    batch.set(_receiverChat, {
      'isSender': false,
      'message': _inputTextController.text,
      'date': DateTime.now()
    });
    batch.commit().whenComplete(() => print('chat messages added to firebase'));
  }

  String convertTimestampToDate(Timestamp timestamp) {
    DateTime messageDateTime = (timestamp).toDate();
    String formattedDate;

    if (calculateDayDifferenceInDate(messageDateTime) >= 0) {
      formattedDate = DateFormat('HH:mm').format(messageDateTime);
    } else {
      formattedDate = DateFormat('dd.MM kk:mm').format(messageDateTime);
    }
    return formattedDate;
  }

  int calculateDayDifferenceInDate(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}
