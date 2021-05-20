import 'package:cloud_firestore/cloud_firestore.dart';

class WatchlistAd {
  final String adID;
  final String ownerID;
  final String title;
  final String description;
  final List<dynamic> images;
  final Timestamp dateTime;
  final String email;
  final bool archived;
  final String price;
  final String place;
  final bool test;

  WatchlistAd(
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
      this.test
      );
}