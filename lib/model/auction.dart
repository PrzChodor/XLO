import 'package:cloud_firestore/cloud_firestore.dart';

class Auction {
  final String ownerID;
  final String title;
  final String description;
  final List<dynamic> images;
  final Timestamp dateTime;
  final String email;
  final bool archived;

  Auction(this.ownerID, this.title, this.description, this.images,
      this.dateTime, this.email, this.archived);
}
