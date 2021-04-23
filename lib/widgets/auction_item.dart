import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuctionItem extends StatelessWidget {
  final image;
  final title;
  final timeSince;
  final price;
  final place;

  AuctionItem._(this.image, this.title, this.timeSince, this.price, this.place);

  factory AuctionItem(image, title, dateTime, price, place) {
    var difference = DateTime.now().difference(dateTime);
    String time;

    if ((difference.inDays / 365).floor() > 0)
      time = " ${(difference.inDays / 365).floor()} y";
    else if ((difference.inDays / 30).floor() > 0)
      time = " ${(difference.inDays / 30).floor()} m";
    else if (difference.inDays > 0)
      time = " ${difference.inDays} d";
    else if (difference.inHours > 0)
      time = " ${difference.inHours} h";
    else if (difference.inMinutes > 0)
      time = " ${difference.inMinutes} min";
    else
      time = " ${difference.inSeconds} s";

    return new AuctionItem._(image, title, time, price, place);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          image,
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
        Expanded(
          child: Container(
            height: 128,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    child: Text(title,
                        style: new TextStyle(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    alignment: Alignment.topLeft,
                  ),
                  Align(
                    child: Text(
                      "$price zł",
                      style: new TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(place),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Icon(Icons.history), Text(timeSince)])
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
