import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uId;
  String email;
  String displayName;
  String userName;
  String bio;
  String profilePic;
  List followers;
  List following;

  UserModel({
    required this.uId,
    required this.email,
    required this.displayName,
    required this.userName,
    required this.bio,
    required this.profilePic,
    required this.followers,
    required this.following,
  });

  factory UserModel.fromSnap(DocumentSnapshot snap) {
    var snapshoot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uId: snapshoot["uId"],
      email: snapshoot["email"],
      displayName: snapshoot["displayName"],
      userName: snapshoot["userName"],
      bio: snapshoot["bio"],
      profilePic: snapshoot["profilePic"],
      followers: snapshoot["followers"],
      following: snapshoot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uId": uId,
        "email": email,
        "displayName": displayName,
        "userName": userName,
        "bio": bio,
        "profilePic": profilePic,
        "followers": followers,
        "following": following,
      };
}
