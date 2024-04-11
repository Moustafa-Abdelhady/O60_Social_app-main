import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:o_social_app/models/user_model.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot = await users.doc(currentUser.uid).get();
    return UserModel.fromSnap(documentSnapshot);
  }

  signUp({
    required String email,
    required String password,
    required String userName,
    required String display,
  }) async {
    String res = "Some Error";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          display.isNotEmpty) {
        UserCredential userCredintial = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        UserModel userModel = UserModel(
          uId: userCredintial.user!.uid,
          email: email,
          displayName: display,
          userName: userName,
          bio: "",
          profilePic: "",
          followers: [],
          following: [],
        );

        users.doc(userCredintial.user!.uid).set(userModel.toJson());

        res = "Success";
      } else {
        res = "Please enter all fields";
      }
    } on Exception catch (e) {
      return e.toString();
    }
    return res;
  }

  signIn({
    required String email,
    required String password,
  }) async {
    String res = "Some Error";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException : ${e.code}");
      return e.toString();
    } on PlatformException catch (e){
      print("Platform exception : ${e.code}");
    }
    return res;
  }
}
