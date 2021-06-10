import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart';

class FullscreenGallery extends StatefulWidget {
  final List<String> images;
  final int index;
  final bool areImagesLocal;

  FullscreenGallery(this.images, this.index, this.areImagesLocal);

  @override
  _FullscreenGalleryState createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<FullscreenGallery> {
  PageController _galleryController;
  double _currentPage = 0;
  double _scale = 1.0;
  double _previousScale = 0.0;
  Offset _previousPosition = Offset(0, 0);
  Offset _zoomPosition = Offset(0, 0);
  double _panSensitivity = 2;
  GlobalKey _imageKey = GlobalKey();

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _galleryController = PageController(initialPage: widget.index);
    _galleryController.addListener(() {
      setState(() {
        _currentPage = _galleryController.page;
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
                key: _imageKey,
                child: GestureDetector(
                  onScaleStart: (ScaleStartDetails details) {
                    _previousScale = _scale;
                    _previousPosition = details.localFocalPoint;
                    if (details.pointerCount != 1) {
                      _zoomPosition -=
                          (_zoomPosition - details.localFocalPoint) / _scale;
                    }
                  },
                  onScaleUpdate: (ScaleUpdateDetails details) {
                    setState(() {
                      _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
                      if (details.pointerCount == 1) {
                        var delta = _previousPosition - details.localFocalPoint;
                        _previousPosition = details.localFocalPoint;
                        _zoomPosition += delta / (_scale / _panSensitivity);
                      }
                    });
                  },
                  onScaleEnd: (ScaleEndDetails details) {
                    _previousScale = 0.0;
                  },
                  onDoubleTap: () => setState(() {
                    _scale = switchZoom();
                  }),
                  onDoubleTapDown: (details) => _zoomPosition -=
                      (_zoomPosition - details.localPosition) / _scale,
                  child: PageView(
                      physics: _scale != 1.0
                          ? NeverScrollableScrollPhysics()
                          : BouncingScrollPhysics(),
                      controller: _galleryController,
                      children: [
                        for (var image in widget.images)
                          Transform(
                            transform: Matrix4.diagonal3(
                                Vector3(_scale, _scale, _scale)),
                            alignment: getZoomAlignment(),
                            child: widget.areImagesLocal
                                ? Image.file(
                                    File(image),
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    image,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                      ]),
                )),
            _scale == 1
                ? Row(
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
                                    color: CupertinoColors.inactiveGray,
                                    width: 3.0)),
                          ),
                        )
                    ],
                  )
                : Container(),
            _scale == 1
                ? Positioned(
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
                : Container()
          ],
        ),
      ),
    );
  }

  double getIndicatorPosition() {
    var center = MediaQuery.of(context).size.width / 2 - 13;
    var startingOffset = (widget.images.length - 1) * 13;
    return center - startingOffset + 26 * _currentPage;
  }

  double switchZoom() {
    if (_scale < 2.0) {
      return 2.0;
    } else if (_scale < 3.0) {
      return 3.0;
    } else {
      return 1.0;
    }
  }

  Alignment getZoomAlignment() {
    var keyContext = _imageKey.currentContext;
    if (keyContext != null) {
      var box = keyContext.findRenderObject() as RenderBox;
      _zoomPosition = Offset(_zoomPosition.dx.clamp(0.0, box.size.width),
          _zoomPosition.dy.clamp(0.0, box.size.height));
      var x = _zoomPosition.dx - box.size.width / 2;
      var y = _zoomPosition.dy - box.size.height / 2;
      x = x / (box.size.width / 2);
      y = y / (box.size.height / 2);
      x = x.clamp(-1.0, 1.0);
      y = y.clamp(-1.0, 1.0);
      return Alignment(x, y);
    }
    return Alignment(0, 0);
  }
}
