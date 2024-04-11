import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/models/user_model.dart';
import 'package:o_social_app/providers/user_provider.dart';
import 'package:o_social_app/services/cloud.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.postId});

  final postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentCont = TextEditingController();

  postComment(String uId, String profilePic, String displayName,
      String userName) async {
    String res = await CloudMethods().CommentToPost(
        postId: widget.postId,
        uId: uId,
        commentText: commentCont.text,
        profilePic: profilePic,
        displayName: displayName,
        userName: userName);
    if (res == 'Success') {
      setState(() {
        commentCont.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 500),
          content: Center(
            child: Text(
              'Comment Successfully',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userData = Provider.of<UserProvider>(context).userModel!;
    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId)
                        .collection('comments')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      dynamic commentLen = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                        itemCount: commentLen.docs.length,
                        itemBuilder: ((context, index) {
                          dynamic data = commentLen.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: kWhiteColor,
                                  // color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      data['profilePic'] == null
                                          ? const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/man.png '))
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  data['profilePic'])),
                                      const Gap(10),
                                      Text(data['displayName'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const Gap(10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data['commentText'],
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }),
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: kPrimaryColor),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: TextField(
                            controller: commentCont,
                            cursorColor: kSecondaryColor,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: 'Type Comment',
                              border: InputBorder.none,
                            ),
                          ))),
                  const Gap(10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(14),
                          backgroundColor: kSecondaryColor,
                          foregroundColor: kWhiteColor),
                      onPressed: () {
                        postComment(
                          userData.uId,
                          userData.profilePic,
                          userData.displayName,
                          userData.userName,
                        );
                      },
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                      )),
                ],
              ),
              const Gap(10),
            ],
          ),
        ));
  }
}
