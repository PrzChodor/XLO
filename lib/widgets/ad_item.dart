import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdItem extends StatelessWidget {
  final _image;
  final _title;
  final _timeSince;
  final _price;
  final _place;
  final _id;

  AdItem._(this._image, this._title, this._timeSince, this._price, this._place,
      this._id);

  factory AdItem(image, title, dateTime, price, place, id) {
    var difference = DateTime.now().difference(dateTime);
    String time;

    if ((difference.inDays / 365).floor() > 0) {
      time = " ${(difference.inDays / 365).floor()} y";
    } else if ((difference.inDays / 30).floor() > 0) {
      time = " ${(difference.inDays / 30).floor()} m";
    } else if (difference.inDays > 0) {
      time = " ${difference.inDays} d";
    } else if (difference.inHours > 0) {
      time = " ${difference.inHours} h";
    } else if (difference.inMinutes > 0) {
      time = " ${difference.inMinutes} min";
    } else {
      time = " ${difference.inSeconds} s";
    }

    return new AdItem._(image, title, time, price, place, id);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: _id,
          child: Image.network(
            _image,
            width: 128,
            height: 128,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  child: CupertinoActivityIndicator(
                    radius: 32,
                  ),
                  width: 128,
                  height: 128,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Container(
            height: 128,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    child: Text(_title,
                        style: new TextStyle(
                            fontSize: 16,
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
                      "$_price zł",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoTheme.of(context).primaryColor),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _place,
                        style: TextStyle(
                            color: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .color),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Icon(Icons.history),
                        Text(
                          _timeSince,
                          style: TextStyle(
                              color: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .color),
                        )
                      ])
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
