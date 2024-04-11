import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/models/user_model.dart';
import 'package:o_social_app/providers/user_provider.dart';
import 'package:o_social_app/services/cloud.dart';
import 'package:o_social_app/utils/picker.dart';
import 'package:provider/provider.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  Uint8List? file;

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userData = Provider.of<UserProvider>(context).userModel!;
    TextEditingController displayCon = TextEditingController();
    TextEditingController userNameCon = TextEditingController();
    TextEditingController bioCon = TextEditingController();
    displayCon.text = userData.displayName;
    userNameCon.text = userData.userName;
    bioCon.text = userData.bio;

    updateProfile() async {
      try {
        String res = await CloudMethods().editUserProfile(
          uId: userData.uId,
          displayName: displayCon.text,
          userName: userNameCon.text,
          bio: bioCon.text,
          file: file,
        );
        if (res == 'Success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text(
                  'Updated',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          );
          Navigator.pop(context);
        }
      } on Exception catch (e) {
        // TODO
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Details'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Gap(20),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      file == null || file == 'assets/images/man.png'
                          ? const CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  AssetImage('assets/images/man.png'),
                            )
                          : CircleAvatar(
                              radius: 70,
                              backgroundImage: MemoryImage(file as Uint8List),
                            ),
                      Positioned(
                        bottom: -7,
                        right: -5,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: kSecondaryColor,
                          ),
                          onPressed: () async {
                            if (file == null || file == '') {
                              dynamic myFile = await pickImage() ?? '';
                            }
                            Uint8List myFile = await pickImage() ?? '';
                            setState(() {
                              file = myFile;
                            });
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                TextField(
                  controller: displayCon,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    labelStyle: TextStyle(color: kPrimaryColor),
                    fillColor: kWhiteColor.withOpacity(.4),
                    filled: true,
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Edit name',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(16)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const Gap(20),
                TextField(
                  controller: userNameCon,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: kPrimaryColor),
                    fillColor: kWhiteColor.withOpacity(.4),
                    filled: true,
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Edit user',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(16)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const Gap(20),
                TextField(
                  controller: bioCon,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: TextStyle(color: kPrimaryColor),
                    fillColor: kWhiteColor.withOpacity(.4),
                    filled: true,
                    prefixIcon: const Icon(Icons.info),
                    hintText: 'Edit bio',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(16)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const Gap(20),
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        updateProfile();
                      },
                      child: Text(
                        'update'.toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ));
  }
}
