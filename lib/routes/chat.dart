import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/model/chatMessage.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _inputTextController = TextEditingController();
  final messages = [];
  // lappop
  static const String sender = 'sQqGbK2fJsMdJp2wW5gU6pOguQs2';
  // bartosz
  static const String receiver = '9otfUuuSCrPtgZKmNlpx6bgyXH82';

  @override
  void dispose() {
    _inputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                List<ChatMessage> messages = snapshot.data.docs
                    .map<ChatMessage>((e) =>
                        ChatMessage(e['isSender'], e['message'], e['date']))
                    .toList();
                return Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      index = (index + 1 - messages.length).abs();
                      return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Text(
                                messages[index].message,
                                style: TextStyle(
                                    fontSize: 15, color: CupertinoColors.black),
                              ),
                            ),
                          ));
                    },
                  ),
                );
              },
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: double.infinity,
              color: CupertinoColors.white,
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
                      onPressed: () => addMessage(context),
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
        ));
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
}
