import 'package:flutter/cupertino.dart';

class FullscreenGallery extends StatefulWidget {
  final List<String> images;
  final int index;

  FullscreenGallery(this.images, this.index);

  @override
  _FullscreenGalleryState createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<FullscreenGallery> {
  PageController galleryController;
  double currentPage = 0;

  @override
  void dispose() {
    galleryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    galleryController = PageController(initialPage: widget.index);
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
        middle: Text("Photos"),
      ),
      child: SafeArea(
        child: Stack(
          alignment: Alignment(0, 0.9),
          children: [
            Container(
                child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: galleryController,
                    children: [
                  for (var image in widget.images)
                    GestureDetector(
                      child: Image.network(
                        image,
                        fit: BoxFit.contain,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ),
                    )
                ])),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.images.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: CupertinoColors.inactiveGray, width: 3.0)),
                    ),
                  )
              ],
            ),
            Positioned(
              left: getIndicatorPosition(),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: CupertinoTheme.of(context).primaryColor,
                          width: 6.0)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  double getIndicatorPosition() {
    var center = MediaQuery.of(context).size.width / 2 - 13;
    var startingOffset = (widget.images.length - 1) * 13;
    return center - startingOffset + 26 * currentPage;
  }
}
