
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String uId;
  String displayName;
  String userName;
  String profilePic;
  String description;
  String postId;
  String postImage;
  DateTime date;
  dynamic like;

  PostModel({
    required this.uId,
    required this.date,
    required this.displayName,
    required this.userName,
    required this.description,
    required this.profilePic,
    required this.like,
    required this.postId,
    required this.postImage,
  });

  factory PostModel.fromSnap(DocumentSnapshot snap) {
    var snapshoot = snap.data() as Map<String, dynamic>;
    return PostModel(
      uId: snapshoot["uId"],
      date: snapshoot["date"],
      displayName: snapshoot["displayName"],
      userName: snapshoot["userName"],
      description: snapshoot["description"],
      profilePic: snapshoot["profilePic"],
      like: snapshoot["like"],
      postId: snapshoot["postId"],
      postImage: snapshoot["postImage"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uId": uId,
        "date": date,
        "displayName": displayName,
        "userName": userName,
        "description": description,
        "profilePic": profilePic,
        "like": like,
        "postId": postId,
        "postImage": postImage,
      };
}
