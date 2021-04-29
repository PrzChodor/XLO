import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/model/chatMessage.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  final _inputTextController = TextEditingController();
  List<ChatMessage> messages = [];
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
                return Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(
                      radius: min(MediaQuery.of(context).size.width * 0.1,
                          MediaQuery.of(context).size.height * 0.1),
                    ),
                  ),
                );
              }

              messages = snapshot.data.docs
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
                                borderRadius: getBorderRadius(index),
                              ),
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                messages[index].message,
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
                              padding: isMessageDateShownIndex == index
                                  ? EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 8.0)
                                  : EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 8.0),
                              child: AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                vsync: this,
                                child: Container(
                                  height: isMessageDateShownIndex == index
                                      ? null
                                      : 0.0,
                                  child: Text(
                                    convertTimestampToDate(
                                        messages[index].date),
                                    style: TextStyle(
                                        color: CupertinoColors.inactiveGray,
                                        fontSize: 14),
                                  ),
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: CupertinoTheme.of(context).primaryColor)),
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
                      Icons.send,
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

  BorderRadius getBorderRadius(int index) {
    Radius tl = Radius.circular(20);
    Radius tr = Radius.circular(20);
    Radius bl = Radius.circular(20);
    Radius br = Radius.circular(20);

    if (messages[index].isSender) {
      if (index > 0 && messages[index - 1].isSender) tr = Radius.circular(5);
      if (index < messages.length - 1 && messages[index + 1].isSender)
        br = Radius.circular(5);
    } else {
      if (index > 0 && !messages[index - 1].isSender) tl = Radius.circular(5);
      if (index < messages.length - 1 && !messages[index + 1].isSender)
        bl = Radius.circular(5);
    }
    return BorderRadius.only(
        topLeft: tl, topRight: tr, bottomLeft: bl, bottomRight: br);
  }
}
