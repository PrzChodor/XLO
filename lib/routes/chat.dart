import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _inputTextController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  static const messages = [
    "hello",
    "shallom",
    "weirdo",
    "3outthere",
    "3outthere",
    "3outthere",
    "3outthere",
    "3outthere",
    "3outthere",
    "end"
  ];

  @override
  void dispose() {
    _inputTextController.dispose();
    _scrollController.dispose();
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
            Expanded(
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
                            color: CupertinoColors.activeBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            messages[index],
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ));
                },
              ),
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
                      onPressed: () {},
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
}
