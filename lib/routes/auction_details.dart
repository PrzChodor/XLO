import 'package:flutter/cupertino.dart';
import 'package:xlo_auction_app/model/auction.dart';
import 'package:intl/intl.dart';
import 'package:xlo_auction_app/routes/fullscreen_gallery.dart';
import 'package:xlo_auction_app/widgets/notification.dart';

class AuctionDetails extends StatefulWidget {
  final Auction auction;

  AuctionDetails(this.auction);

  @override
  State<StatefulWidget> createState() => _AuctionDetailsState();
}

class _AuctionDetailsState extends State<AuctionDetails> {
  final PageController galleryController = PageController();
  double currentPage = 0;
  List<String> images;

  @override
  void dispose() {
    galleryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    images = List<String>.from(widget.auction.images);
    galleryController.addListener(() {
      setState(() {
        currentPage = galleryController.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Auction details'),
      ),
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment(0, 0.8),
                    children: [
                      Container(
                        width: double.infinity,
                        height: 256,
                        child: PageView(
                          controller: galleryController,
                          physics: ClampingScrollPhysics(),
                          children: [
                            for (var i = 0; i < images.length; i++)
                              GalleryPage(
                                images: images,
                                index: i,
                              )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < images.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: CupertinoColors.inactiveGray,
                                        width: 3.0)),
                              ),
                            )
                        ],
                      ),
                      Positioned(
                        left: getIndicatorPosition(),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: CupertinoTheme.of(context)
                                        .scaffoldBackgroundColor,
                                    width: 5.0)),
                          ),
                        ),
                      )
                    ],
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

  double getIndicatorPosition() {
    var center = MediaQuery.of(context).size.width / 2 - 10;
    var startingOffset = (images.length - 1) * 10;
    return center - startingOffset + 20 * currentPage;
  }
}

class GalleryPage extends StatelessWidget {
  final List<String> images;
  final int index;

  GalleryPage({this.images, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => FullscreenGallery(images, index))),
      child: Image.network(
        images[index],
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
    );
  }
}
