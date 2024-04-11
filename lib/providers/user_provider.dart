import 'package:flutter/material.dart';
import 'package:o_social_app/models/user_model.dart';
import 'package:o_social_app/services/auth.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  bool isLoad = true;

  getDetails() async {
    userModel = await AuthMethods().getUserDetails();
    isLoad = false;
    notifyListeners();
  }
}
