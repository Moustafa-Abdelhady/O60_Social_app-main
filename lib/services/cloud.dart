import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_social_app/models/message.dart';
import 'package:o_social_app/models/post_model.dart';
import 'package:o_social_app/services/storage.dart';
import 'package:uuid/uuid.dart';

final chatRoomId = const Uuid().v1();

class CloudMethods {
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  List<Message> messagesList = [];

  uploadPost({
    required String description,
    required String uId,
    required String displayName,
    required String userName,
    Uint8List? file,
    String? profilePic,
  }) async {
    String res = 'Some Error';
    try {
      String postId = const Uuid().v1();

      // late String postImage;
      String? postImage;
      if (file != null) {
        postImage = await StorageMethods().uploadImageToStorage(
          file,
          'posts',
          true,
        );
      }

      PostModel postModel = PostModel(
          uId: uId,
          date: DateTime.now(),
          displayName: displayName,
          userName: userName,
          description: description,
          profilePic: profilePic ?? '',
          like: [],
          postId: postId,
          postImage: postImage ?? '');

      await posts.doc(postId).set(postModel.toJson());
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  sendMessage(
      {required String message,
      required String email,
      required String toEmail}) {
    try {
      messages.add({
        'message': message,
        'createdAt': DateTime.now().toString().substring(10, 16),
        'fromId': email,
        'toId': toEmail,
      });
    } on Exception catch (e) {
      print('something went wrong');
      return e.toString();
    }
  }

  getMessages() {
    messages.orderBy('createdAt', descending: true).snapshots().listen((event) {
      print(event.docs);
      messagesList.clear();

      for (var doc in event.docs) {
        messagesList.add(Message.fromJsson(doc));
      }
      print('Success');
    });
  }

  CommentToPost({
    required String postId,
    required String uId,
    required String commentText,
    required String profilePic,
    required String displayName,
    required String userName,
  }) async {
    String res = "There's an Error";
    try {
      if (commentText.isNotEmpty) {
        String commentId = Uuid().v1();
        posts.doc(postId).collection('comments').doc(commentId).set({
          'uId': uId,
          'postId': postId,
          'commentId': commentId,
          "commentText": commentText,
          "profilePic": profilePic,
          'displayName': displayName,
          'userName': userName,
          'date': DateTime.now().hour,
        });
        res = "Success";
      }
    } on Exception catch (e) {
      return e.toString();
    }
    return res;
  }

  likePost(String postId, String uId, List like) async {
    String res = "There's an Error";

    try {
      if (like.contains(uId)) {
        posts.doc(postId).update({
          'like': FieldValue.arrayRemove([uId])
        });
      } else {
        posts.doc(postId).update({
          'like': FieldValue.arrayUnion([uId])
        });
        res = "You already liked this Post!";
      }
    } on Exception catch (e) {
      e.toString();
    }
    return res;
  }

  followUser(String uId, String followUserId) async {
    DocumentSnapshot documentSnapshot = await users.doc(uId).get();
    List following = (documentSnapshot.data()! as dynamic)['following'];
    try {
      if (following.contains(followUserId)) {
        await users.doc(uId).update({
          'following': FieldValue.arrayRemove([followUserId])
        });
        print("Already Following");

        await users.doc(followUserId).update({
          'followers': FieldValue.arrayRemove([uId])
        });
      } else {
        await users.doc(uId).update({
          'following': FieldValue.arrayUnion([followUserId])
        });

        await users.doc(followUserId).update({
          'followers': FieldValue.arrayUnion([uId])
        });
      }
    } on Exception catch (e) {
      e.toString();
    }
  }

  editUserProfile({
    required String uId,
    required String displayName,
    required String userName,
    Uint8List? file,
    String bio = "",
    String profilePic = "",
  }) async {
    String res = "there's an Error";
    try {
      profilePic = file != null
          ? await StorageMethods().uploadImageToStorage(file, 'users', false)
          : "assets/images/man.png";
      if (displayName != "" && userName != "") {
        users.doc(uId).update({
          'displayName': displayName,
          'userName': userName,
          'bio': bio,
          'profilePic': profilePic,
        });
        res = 'Succes';
      }
    } on Exception catch (e) {
      res = e.toString();
    }
    return res;
  }

  deletePost(String postId) async {
    String res = "There's an Error";
    try {
      await posts.doc(postId).delete();
      res = "Success";
    } catch (e) {
      e.toString();
    }
    return res;
  }
}
