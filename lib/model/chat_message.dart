import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final bool isSender;
  final String message;
  final Timestamp date;

  ChatMessage(this.isSender, this.message, this.date);
}
