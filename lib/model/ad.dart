import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  final String adID;
  final String ownerID;
  final String title;
  final String description;
  final List<dynamic> images;
  final Timestamp dateTime;
  final String email;
  bool archived;
  final String price;
  final String place;
  final bool test;
  final List<dynamic> bookmarkedBy;

  Ad(
    this.adID,
    this.ownerID,
    this.title,
    this.description,
    this.images,
    this.dateTime,
    this.email,
    this.archived,
    this.price,
    this.place,
    this.test,
    this.bookmarkedBy
  );

}
