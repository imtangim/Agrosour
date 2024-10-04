import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nasa_space_app/homepage/model/comment.dart';
import 'package:nasa_space_app/homepage/model/main_post_model.dart';
import 'package:nasa_space_app/homepage/model/post_model.dart';

import 'package:nasa_space_app/homepage/model/usermodel.dart';
import 'package:uuid/uuid.dart';

class PostService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uuid = const Uuid();
  bool isloading = false;

  Future<List<String>> uploadImages(List<XFile> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      File file = File(image.path);
      String imageName = image.path.split("/").last;
      try {
        Reference storageRef = _storage
            .ref()
            .child('posts_images')
            .child(auth.currentUser!.uid)
            .child(imageName);
        await storageRef.putFile(file);

        String downloadUrl = await storageRef.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        log(e.toString());
      }
    }
    return imageUrls;
  }

  Future<void> createPost(
      {required String postText, required List<XFile>? images}) async {
    isloading = true;
    update();
    try {
      String uid = auth.currentUser!.uid;

      List<String> imageLinks = [];
      log("Uploadingimage..............");

      if (images != null && images.isNotEmpty) {
        imageLinks = await uploadImages(images);
      }

      log("Uploading image finish..............");

      Map<String, dynamic> postData = {
        'post': postText,
        'post_user_uid': uid,
        'image_list': imageLinks,
        'timestamp': FieldValue.serverTimestamp(),
        'comment': [],
        'reaction': [],
        'post_id': uuid.v4(),
      };

      await _firestore.collection('posts').add(postData);
      debugPrint('Post created successfully');
      Get.back();
    } catch (e) {
      debugPrint('Error creating post: $e');
    } finally {
      isloading = false;
      update();
    }
  }

  Stream<List<MainPostModel>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot snapshot) async {
      List<MainPostModel> mainPostList = [];

      for (var doc in snapshot.docs) {
        PostModel postModel =
            PostModel.fromFirestore(doc.data() as Map<String, dynamic>);

        Usermodel? usermodel = await getUserData(postModel.postUserUid);

        MainPostModel mainPostModel =
            MainPostModel(usermodel: usermodel!, postModel: postModel);

        mainPostList.add(mainPostModel);
      }

      return mainPostList;
    });
  }

  Future<void> addComment(
      {required String text,
      required String userId,
      required String postId}) async {
    isloading = true;
    update();
    try {
      String commentId = uuid.v4();

      Map<String, dynamic> commentData = {
        'text': text,
        'userid': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'postID': postId,
        'commentid': commentId,
      };

      await _firestore.collection('comments').add(commentData);

      QuerySnapshot postSnapshot = await _firestore
          .collection('posts')
          .where('post_id', isEqualTo: postId)
          .get();

      if (postSnapshot.docs.isNotEmpty) {
        String docId = postSnapshot.docs.first.id;

        await _firestore.collection('posts').doc(docId).update({
          'comment': FieldValue.arrayUnion(
            [commentId],
          ),
        });

        log('Comment added and post updated successfully');
      } else {
        log('Post not found');
      }

      log('Comment added and post updated successfully');
    } catch (e) {
      log('Error adding comment: $e');
    } finally {
      isloading = false;
      update();
    }
  }

  Stream<List<Comment>> getCommentsForPostWithUser(String postId) {
    return _firestore
        .collection('comments')
        .where('postID', isEqualTo: postId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Comment> comments = [];
      for (var doc in querySnapshot.docs) {
        Usermodel? user = await getUserData(doc['userid']);
        Comment comment =
            Comment.fromFirestore(doc.data() as Map<String, dynamic>, user!);
        comments.add(comment);
      }
      return comments;
    });
  }

  Future<Usermodel?> getUserData(String userId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return Usermodel.fromMap(userDoc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> addLikeToPost(String postId) async {
    try {
      QuerySnapshot postSnapshot = await _firestore
          .collection('posts')
          .where('post_id', isEqualTo: postId)
          .get();
      if (postSnapshot.docs.isNotEmpty) {
        PostModel post = PostModel.fromFirestore(
            postSnapshot.docs.first.data() as Map<String, dynamic>);

        if (!post.reaction.contains(auth.currentUser!.uid)) {
          post.reaction.add(auth.currentUser!.uid);

          await _firestore
              .collection('posts')
              .doc(postSnapshot.docs.first.id)
              .update(post.toFirestore());
        }
      }
    } catch (e) {
      log("Error adding like to post: $e");
    }
  }

  Future<void> removeLikeFromPost(String postId) async {
    try {
      QuerySnapshot postSnapshot = await _firestore
          .collection('posts')
          .where('post_id', isEqualTo: postId)
          .get();

      if (postSnapshot.docs.isNotEmpty) {
        PostModel post = PostModel.fromFirestore(
            postSnapshot.docs.first.data() as Map<String, dynamic>);

        if (post.reaction.contains(auth.currentUser!.uid)) {
          post.reaction.remove(auth.currentUser!.uid);

          await _firestore
              .collection('posts')
              .doc(postSnapshot.docs.first.id)
              .update(post.toFirestore());
        }
      }
    } catch (e) {
      log("Error removing like from post: $e");
    }
  }

  Stream<bool> isUserLikedPostStream(String postId) async* {
    yield* _firestore
        .collection('posts')
        .where('post_id', isEqualTo: postId)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        PostModel post =
            PostModel.fromFirestore(querySnapshot.docs.first.data());

        return post.reaction.contains(auth.currentUser!.uid);
      }
      return false;
    });
  }

  Stream<int> getReactionCountStream(String postId) async* {
    yield* _firestore
        .collection('posts')
        .where('post_id', isEqualTo: postId)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        PostModel post =
            PostModel.fromFirestore(querySnapshot.docs.first.data());

        return post.reaction.length;
      }
      return 0;
    });
  }

  Stream<int> getCommentCountStream(String postId) async* {
    yield* _firestore
        .collection('posts')
        .where('post_id', isEqualTo: postId)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        PostModel post =
            PostModel.fromFirestore(querySnapshot.docs.first.data());

        return post.comment.length;
      }
      return 0;
    });
  }

  Future<void> deletePost(String postId) async {
    QuerySnapshot commentsSnapshot = await _firestore
        .collection('comments')
        .where('post_id', isEqualTo: postId)
        .get();

    for (var commentDoc in commentsSnapshot.docs) {
      await commentDoc.reference.delete();
    }

    QuerySnapshot<Map<String, dynamic>> postRef = await _firestore
        .collection('posts')
        .where('post_id', isEqualTo: postId)
        .get();
    await postRef.docs.first.reference.delete();
  }

  Stream<List<MainPostModel>> getUserPostsStream() {
  return _firestore
      .collection('posts')
      .where('post_user_uid', isEqualTo: auth.currentUser!.uid) // Filter by user ID
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap((QuerySnapshot snapshot) async {
        List<MainPostModel> mainPostList = [];

        for (var doc in snapshot.docs) {
          PostModel postModel =
              PostModel.fromFirestore(doc.data() as Map<String, dynamic>);

          // Fetch user data for the post
          Usermodel? usermodel = await getUserData(postModel.postUserUid);

          // Create MainPostModel with the fetched user data and post
          MainPostModel mainPostModel =
              MainPostModel(usermodel: usermodel!, postModel: postModel);

          mainPostList.add(mainPostModel);
        }

        return mainPostList; // Return the list of MainPostModel
      });
}

}
