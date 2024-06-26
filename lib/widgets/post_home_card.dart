import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/models/user_model.dart';
import 'package:o_social_app/pages/comment_screen.dart';
import 'package:o_social_app/providers/user_provider.dart';
import 'package:o_social_app/services/cloud.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.item,
  });

  final item;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentCount = 0;

  @override
  void initState() {
    getComentCount();
    super.initState();
  }

  getComentCount() async {
    try {
      QuerySnapshot comments = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.item['postId'])
          .collection('comments')
          .get();
      if (this.mounted) {
        setState(() {
          commentCount = comments.docs.length;
        });
      }
    } on Exception catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userData = Provider.of<UserProvider>(context).userModel!;
    print('desc' + widget.item['description']);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kWhiteColor.withOpacity(.2),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                widget.item['uId'] != userData.uId && userData.profilePic == ""
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/man.png'),
                      )
                    : userData.profilePic != ""
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(userData.profilePic),
                          )
                        : const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/man.png'),
                          ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item['displayName'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("@" + widget.item['userName']),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(widget.item['date']
                        .toDate()
                        .toString()
                        .substring(0, 16)),
                  ],
                ),
              ],
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item['description'],
                      style: const TextStyle(fontSize: 18),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: widget.item['postImage'] != ""
                      ? Container(
                          margin: const EdgeInsets.all(12),
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.item['postImage']),
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(12),
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: widget.item['like'].contains(userData.uId)
                      ? Icon(Icons.favorite, color: kPrimaryColor)
                      : const Icon(Icons.favorite),
                  onPressed: () {
                    CloudMethods().likePost(widget.item['postId'], userData.uId,
                        widget.item['like']);
                  },
                ),
                Text(widget.item['like'].length.toString()),
                const Gap(70),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) =>
                            CommentScreen(postId: widget.item['postId'])),
                      ),
                    );
                  },
                ),
                Text(commentCount.toString()),
                const Gap(70),
                IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      var alert = AlertDialog(actions: [
                        Center(
                          child: GestureDetector(
                              onTap: () {
                                CloudMethods()
                                    .deletePost(widget.item['postId']);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: kSecondaryColor,
                                      ),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: kSecondaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              )),
                        ),
                      ]);
                      showDialog(context: context, builder: (context) => alert);
                    }),
                // const Text('0'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
