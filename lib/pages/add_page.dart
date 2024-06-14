import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/models/user_model.dart';
import 'package:o_social_app/navigation_bar_layout.dart';

import 'package:o_social_app/providers/user_provider.dart';
import 'package:o_social_app/services/cloud.dart';
import 'package:o_social_app/utils/picker.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  dynamic file;

  TextEditingController descCont = TextEditingController();

  uploadPost(
    String uId,
    String displayName,
    String userName,
    String profilePic,
    String description,
    Uint8List? file,
  ) async {
    try {
      String res = await CloudMethods().uploadPost(
        description: description.isNotEmpty ? descCont.text : description,
        uId: uId,
        profilePic: profilePic,
        displayName: displayName,
        userName: userName,
        file: file,
      );
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userDetail = Provider.of<UserProvider>(context).userModel!;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.amber,
        title: const Text(
          "Add Post",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              uploadPost(
                  userDetail.uId,
                  userDetail.displayName,
                  userDetail.userName,
                  userDetail.profilePic,
                  descCont.text,
                  file);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const NavBarLayout()),
                  (route) => false);
            },
            child: const Text(
              "Post",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                userDetail.profilePic == ''
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/man.png'),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(userDetail.profilePic),
                      ),
                const Gap(20),
                Expanded(
                  child: TextField(
                    controller: descCont,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Type here ..."),
                  ),
                ),
              ],
            ),
            Expanded(
              child: file == null || file == ''
                  ? Container()
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: MemoryImage(file),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            const Gap(20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                backgroundColor: kSecondaryColor,
              ),
              onPressed: () async {
                if (file == null || file == '') {
                  file = AssetImage('assets/images/man.png')
                      as ImageProvider<Object>;
                }
                Uint8List? myFile = await pickImage();
                setState(() {
                  file = myFile;
                });
              },
              child: Icon(
                semanticLabel: "media",
                Icons.camera,
                color: kWhiteColor,
              ),
            ),
            const Gap(70),
          ],
        ),
      ),
    );
  }
}
