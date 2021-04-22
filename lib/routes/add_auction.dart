import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
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
import 'package:screen_loader/screen_loader.dart';

var uuid = Uuid();

class AddAuction extends StatefulWidget {
  @override
  _AddAuctionState createState() => _AddAuctionState();
}

class _AddAuctionState extends State<AddAuction> with ScreenLoader<AddAuction> {
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
  Widget screen(BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildGridView(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton.filled(
                    child: Text('Add auction'),
                    onPressed: () async {
                      await this.performFuture(() => addAuction(context));
                    },
                  ),
                ),
              ],
            ),
          ),
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
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
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
      images = resultList;
    });
  }

  Widget buildGridView() {
    return GridView.count(
        primary: false,
        shrinkWrap: true,
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        children: List.generate(images.length + 1, (index) {
          if (index < images.length) {
            Asset asset = images[index];
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
                  color: CupertinoColors.white,
                  size: 64,
                ),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              onTap: loadAssets,
            );
          }
        }));
  }

  Future<void> addAuction(BuildContext context) async {
    if (titleController.text.trim().isEmpty) {
      showNotification(context, "Error", "Enter title!");
      return;
    } else if (descriptionController.text.trim().isEmpty) {
      showNotification(context, "Error", "Enter description!");
      return;
    } else if (images.isEmpty) {
      showNotification(context, "Error", "Select atleast one image!");
      return;
    }

    final _auth = context.read<AuthenticationService>();
    final _firestore = context.read<FirebaseFirestore>();

    await uploadImages(context);

    CollectionReference _auctions = _firestore.collection('auctions');

    await _auctions
        .add({
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'ownerID': _auth.getCurrentUserId(),
          'email': _auth.getCurrentUserEmail(),
          'date': DateTime.now(),
          'archived': false,
          'images': FieldValue.arrayUnion(imageUrls)
        })
        .then((value) => {
              showNotification(
                  context, 'Success', 'Auction added successfully'),
              Navigator.pop(context)
            })
        .catchError((error) => showNotification(
            context, 'Error', "Failed to add auction!\n$error"));
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
