import 'package:flutter/cupertino.dart';
import 'package:xlo_auction_app/model/auction.dart';
import 'package:intl/intl.dart';
import 'package:xlo_auction_app/widgets/notification.dart';

class AuctionDetails extends StatefulWidget {
  final Auction auction;

  AuctionDetails(this.auction, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuctionDetailsState();
}

class _AuctionDetailsState extends State<AuctionDetails> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Auction details'),
      ),
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    widget.auction.images[0],
                    width: MediaQuery.of(context).size.width,
                    height: 256,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          child: CupertinoActivityIndicator(
                            radius: 64,
                          ),
                          width: 256,
                          height: 256,
                        ),
                      );
                    },
                  ),
                  Container(
                    transform: Matrix4.translationValues(0, -16, 0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.black.withOpacity(0.3),
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          offset: Offset(0, -5.0),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat('dd MMMM yyyy').format(
                                        widget.auction.dateTime.toDate()),
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .merge(TextStyle(
                                            color: CupertinoTheme.of(context)
                                                .primaryColor)),
                                  ),
                                  Spacer(),
                                  CupertinoButton(
                                      child: Icon(
                                        CupertinoIcons.heart,
                                      ),
                                      onPressed: () => showNotification(
                                          context,
                                          "AuctionID",
                                          widget.auction.auctionID)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.auction.title,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .navLargeTitleTextStyle
                                    .merge(TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 32)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.auction.price + " zł",
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .navLargeTitleTextStyle
                                      .merge(TextStyle(
                                          color: CupertinoTheme.of(context)
                                              .primaryColor))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Description',
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .merge(TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.auction.description,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Icon(
                                  CupertinoIcons.person_crop_circle,
                                  size: 48,
                                ),
                              ),
                              Text(
                                  widget.auction.email.substring(
                                      0, widget.auction.email.indexOf('@')),
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .merge(TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: CupertinoTheme.of(context)
                                              .primaryColor))),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: CupertinoButton(
                                        child: Icon(
                                          CupertinoIcons.envelope_fill,
                                          size: 32,
                                        ),
                                        onPressed: () => showNotification(
                                            context,
                                            "UserID",
                                            widget.auction.ownerID)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Icon(
                                  CupertinoIcons.map_fill,
                                  size: 48,
                                ),
                              ),
                              Text(widget.auction.place,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .merge(TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: CupertinoTheme.of(context)
                                              .primaryColor))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
