// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:nasa_space_app/homepage/model/usermodel.dart';

class Comment {
  final String text;
  final String userId;
  final String timestamp;
  final String postId;
  final String commentId;
  final Usermodel user;

  Comment({
    required this.text,
    required this.userId,
    required this.timestamp,
    required this.postId,
    required this.commentId,
    required this.user,
  });

  // Factory method to create a Comment from Firestore document
  factory Comment.fromFirestore(Map<String, dynamic> data, Usermodel user) {
    return Comment(
      text: data['text'],
      userId: data['userid'],
      timestamp: data['timestamp'].toDate().toString(), // Adjust to your needs
      postId: data['postID'],
      commentId: data['commentid'],
      user: user,
    );
  }
}
