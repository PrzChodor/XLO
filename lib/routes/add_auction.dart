import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/authentication/notification.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class AddAuction extends StatefulWidget {
  @override
  _AddAuctionState createState() => _AddAuctionState();
}

class _AddAuctionState extends State<AddAuction> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<Asset> images = <Asset>[];
  List<String> imageUrls = <String>[];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Add auction'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoTextField(
                  controller: titleController,
                  placeholder: 'Title',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoTextField(
                  controller: descriptionController,
                  placeholder: 'Description',
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 8,
                ),
              ),
              CupertinoButton(
                child: Text('Add images'),
                onPressed: () => loadAssets(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildGridView(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton.filled(
                  child: Text('Add auction'),
                  onPressed: () => addAuction(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: '#2196f3',
          actionBarTitle: "Choose photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      log(e.toString());
    }

    setState(() {
      images = resultList;
    });
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        primary: false,
        shrinkWrap: true,
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: CupertinoColors.activeBlue);
  }

  Future<void> addAuction(BuildContext context) async {
    final _auth = context.read<AuthenticationService>();
    final _firestore = context.read<FirebaseFirestore>();

    await uploadImages(context);

    CollectionReference _auctions = _firestore.collection('auctions');

    final documentSnapshot = await _auctions.add({
      'title': titleController.text,
      'description': descriptionController.text,
      'ownerID': _auth.getCurrentUserId(),
      'email': _auth.getCurrentUserEmail(),
      'date': DateTime.now(),
      'archived': false
    });

    Navigator.pop(context);
    documentSnapshot.update({'images': FieldValue.arrayUnion(imageUrls)});
    showNotification(context, 'Success', 'Auction added successfully');
  }

  Future<void> uploadImages(BuildContext context) async {
    final _auth = Provider.of<AuthenticationService>(context, listen: false);
    final _storage = Provider.of<FirebaseStorage>(context, listen: false);
    final loggedUser = _auth.getCurrentUserId();

    for (var imageAsset in images) {
      final imageName = uuid.v4();
      File imageFile = await getImageFileFromAssets(imageAsset);

      final taskSnapshot =
          await _storage.ref('$loggedUser/$imageName').putFile(imageFile);

      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        imageUrls.add(imageUrl);
      });
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }
}
