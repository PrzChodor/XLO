import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/model/ad.dart';
import 'package:xlo_auction_app/routes/ads/ad_details.dart';
import 'package:xlo_auction_app/widgets/notification.dart';
import 'package:uuid/uuid.dart';
import 'package:screen_loader/screen_loader.dart';

var uuid = Uuid();

class EditAd extends StatefulWidget {
  final Ad originalAd;

  const EditAd({Key key, this.originalAd}) : super(key: key);
  @override
  _EditAdState createState() => _EditAdState();
}

class _EditAdState extends State<EditAd> with ScreenLoader<EditAd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.originalAd.title;
    _descriptionController.text = widget.originalAd.description;
    _priceController.text = widget.originalAd.price;
    _locationController.text = widget.originalAd.place;
    print(widget.originalAd.images);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget screen(BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Edit advertisement'),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoTextField(
                        controller: _titleController,
                        placeholder: 'Title',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoTextField(
                        controller: _descriptionController,
                        placeholder: 'Description',
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: 8,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoTextField(
                        controller: _locationController,
                        placeholder: 'Location',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoTextField(
                        controller: _priceController,
                        placeholder: 'Price',
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: false,
                          signed: false,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: 250,
                        child: CupertinoButton(
                            child: Text('Preview advertisement'),
                            onPressed: () {
                              if (isNewAdValid()) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Navigator.of(context, rootNavigator: true).push(
                                    CupertinoPageRoute(
                                        builder: (context) => AdDetails(Ad(
                                            '',
                                            context
                                                .read<AuthenticationService>()
                                                .getCurrentUserId(),
                                            _titleController.text.trim(),
                                            _descriptionController.text.trim(),
                                            widget.originalAd.images,
                                            Timestamp.fromDate(DateTime.now()),
                                            context
                                                .read<AuthenticationService>()
                                                .getCurrentUsername(),
                                            false,
                                            _priceController.text,
                                            _locationController.text,
                                            true,
                                            widget.originalAd.bookmarkedBy))));
                              }
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 250,
                        child: CupertinoButton.filled(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Edit advertisement'),
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await this.performFuture(() => editAd(context));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
      onWillPop: () async {
        return !isLoading;
      },
    );
  }

  loader() {
    return CupertinoActivityIndicator(
        radius: min(MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.height * 0.1));
  }

  Future<void> editAd(BuildContext context) async {
    Algolia algolia = Algolia.init(
      applicationId: 'ZYVN1G1S7E',
      apiKey: '074c9f69d125d3d81260e64fb5424ace',
    );
    AlgoliaIndexReference index = algolia.instance.index('ads');
    await index.addObject({
      'objectID': widget.originalAd.adID,
      'title': _titleController.text.trim(),
      'archived': widget.originalAd.archived,
      'date': DateTime.now()
    });

    final _firestore = context.read<FirebaseFirestore>();
    CollectionReference _ads = _firestore.collection('ads');
    await _ads.doc(widget.originalAd.adID).update({
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'place': _locationController.text.trim(),
      'price': _priceController.text.trim(),
      'date': DateTime.now()
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  bool isNewAdValid() {
    if (_titleController.text.trim().isEmpty) {
      showNotification(context, "Error", "Enter title!");
      return false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      showNotification(context, "Error", "Enter description!");
      return false;
    }
    if (_locationController.text.trim().isEmpty) {
      showNotification(context, "Error", "Enter location!");
      return false;
    }
    if (_priceController.text.trim().isEmpty) {
      showNotification(context, "Error", "Enter price!");
      return false;
    }
    return true;
  }
}
