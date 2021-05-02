import 'package:cloud_firestore/cloud_firestore.dart';

class Auction {
  final String auctionID;
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

  Auction(
      this.auctionID,
      this.ownerID,
      this.title,
      this.description,
      this.images,
      this.dateTime,
      this.email,
      this.archived,
      this.price,
      this.place,
      this.test);
}
