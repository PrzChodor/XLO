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
import 'package:xlo_auction_app/routes/ad_details.dart';
import 'package:xlo_auction_app/widgets/notification.dart';
import 'package:uuid/uuid.dart';
import 'package:screen_loader/screen_loader.dart';

var uuid = Uuid();

class NewAd extends StatefulWidget {
  @override
  _NewAd createState() => _NewAd();
}

class _NewAd extends State<NewAd> with ScreenLoader<NewAd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  List<String> _bookmarkedBy = <String>[];
  List<Asset> _images = <Asset>[];
  List<String> _imageUrls = <String>[];

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
          middle: Text('Add advertisement'),
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
                      padding: const EdgeInsets.all(8.0),
                      child: buildGridView(),
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
                                            _images,
                                            Timestamp.fromDate(DateTime.now()),
                                            context
                                                .read<AuthenticationService>()
                                                .getCurrentUsername(),
                                            false,
                                            _priceController.text,
                                            _locationController.text,
                                            true,
                                            _bookmarkedBy))));
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
                          child: Text('Add advertisement'),
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await this.performFuture(() => addAd(context));
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

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#007bff",
          actionBarTitle: "Choose photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      dev.log(e.toString());
    }

    setState(() {
      _images = resultList;
    });
  }

  Widget buildGridView() {
    return GridView.extent(
        primary: false,
        shrinkWrap: true,
        maxCrossAxisExtent: 150,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: List.generate(_images.length + 1, (index) {
          if (index < _images.length) {
            Asset asset = _images[index];
            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
                spinner: const Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ),
            );
          } else {
            return GestureDetector(
              child: Container(
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: CupertinoTheme.of(context).primaryContrastingColor,
                  size: 64,
                ),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              onTap: loadAssets,
            );
          }
        }));
  }

  Future<void> addAd(BuildContext context) async {
    if (!isNewAdValid()) return;
    final _auth = context.read<AuthenticationService>();
    final _firestore = context.read<FirebaseFirestore>();

    await uploadImages(context);

    CollectionReference _ads = _firestore.collection('ads');

    await _ads
        .add({
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'ownerID': _auth.getCurrentUserId(),
          'username': _auth.getCurrentUsername(),
          'date': DateTime.now(),
          'archived': false,
          'images': FieldValue.arrayUnion(_imageUrls),
          'price': _priceController.text,
          'place': _locationController.text.trim(),
          'bookmarkedBy': _bookmarkedBy,
        })
        .then((doc) async =>
            await addToAlgolia(doc).catchError((error, stackTrace) {
              showNotification(
                  context, 'Error', "Failed to add advertisement!");
              _ads.doc(doc.id).delete();
            }))
        .catchError((error, stackTrace) {
          showNotification(context, 'Error', "Failed to add advertisement!");
        });
  }

  Future<void> addToAlgolia(DocumentReference doc) async {
    Algolia algolia = Algolia.init(
      applicationId: 'ZYVN1G1S7E',
      apiKey: '074c9f69d125d3d81260e64fb5424ace',
    );

    AlgoliaIndexReference index = algolia.instance.index('ads');
    await index.addObject({
      'objectID': doc.id,
      'title': _titleController.text.trim(),
      'date': Timestamp.fromDate(DateTime.now()).seconds,
      'archived': false
    }).then((value) {
      Navigator.pop(context);
      showNotification(context, 'Success', 'Advertisement added successfully');
    }).catchError((error, stackTrace) {
      throw (error);
    });
  }

  Future<void> uploadImages(BuildContext context) async {
    final _auth = Provider.of<AuthenticationService>(context, listen: false);
    final _storage = Provider.of<FirebaseStorage>(context, listen: false);
    final loggedUser = _auth.getCurrentUserId();

    for (var imageAsset in _images) {
      final imageName = uuid.v4();
      File imageFile = File(
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier));

      final taskSnapshot = await _storage
          .ref('$loggedUser/$imageName')
          .putFile(imageFile)
          .catchError((error, stackTrace) {
        showNotification(context, 'Error', "Failed to upload images!\n$error");
      });

      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      _imageUrls.add(imageUrl);
    }
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
    if (_images.isEmpty) {
      showNotification(context, "Error", "Select at least one image!");
      return false;
    }
    return true;
  }
}
