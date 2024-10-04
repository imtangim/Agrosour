// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postText;
  final String? imageLink;
  final String postUserUid;
  final List<String> imageList;
  final DateTime timestamp;
  final List<dynamic> comment;
  final List<dynamic> reaction;
  final String id;

  PostModel({
    required this.postText,
    this.imageLink,
    required this.postUserUid,
    required this.imageList,
    required this.timestamp,
    required this.comment,
    required this.reaction,
    required this.id,
  });

  // Factory constructor to create a PostModel from a Firebase snapshot
  factory PostModel.fromFirestore(Map<String, dynamic> data) {
    return PostModel(
        postText: data['post'] ?? '',
        imageLink: data['image_link'],
        postUserUid: data['post_user_uid'] ?? '',
        imageList: List<String>.from(data['image_list'] ?? []),
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        comment: data['comment'] ?? [],
        reaction: data['reaction'] ?? [],
        id: data["post_id"]);
  }

  // Method to convert PostModel to a map for storing in Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'post': postText,
      'image_link': imageLink,
      'post_user_uid': postUserUid,
      'image_list': imageList,
      'timestamp': timestamp,
      'comment': comment,
      'reaction': reaction,
      'post_id': id,
    };
  }
}
