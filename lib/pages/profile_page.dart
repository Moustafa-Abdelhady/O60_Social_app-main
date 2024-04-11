import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_stack/image_stack.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/models/user_model.dart';
import 'package:o_social_app/pages/edit_user_profile.dart';
import 'package:o_social_app/providers/user_provider.dart';
import 'package:o_social_app/services/cloud.dart';
import 'package:o_social_app/widgets/post_home_card.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, this.uId});

  String? uId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);

  String myId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    widget.uId = widget.uId ?? FirebaseAuth.instance.currentUser!.uid;
    Provider.of<UserProvider>(context, listen: false).getDetails();
    getUserData();
    super.initState();
  }

  var userInfo = {};
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoad = true;

  getUserData() async {
    try {
      var userDetail = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uId ?? myId)
          .get();

      userInfo = userDetail.data()!;
      isFollowing =
          (userDetail.data()! as dynamic)['followers'].contains(myId); //data()!
      followers = userDetail.data()!['followers'].length;
      following = userDetail.data()!['following'].length;
      setState(() {
        isLoad = false;
      });
    } on Exception catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userDetail = Provider.of<UserProvider>(context).userModel!;

    return isLoad
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: userInfo['uId'] == myId
                ? AppBar(
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditUserProfile()),
                            );
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          setState(() {});
                        },
                        icon: const Icon(Icons.logout),
                      )
                    ],
                  )
                : AppBar(
                    title: Center(
                        child: Text(
                      userInfo['displayName'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kSecondaryColor),
                    )),
                  ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      userInfo['profilePic'] == ""
                          ? const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/man.png'),
                              radius: 40,
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userInfo['profilePic']),
                              radius: 40,
                            ),
                      const Spacer(),
                      Row(children: [
                        FollowersCard(
                          follow: 'Followers',
                          followNum: followers.toString(),
                        ),
                        const Gap(10),
                        FollowersCard(
                          follow: 'Following',
                          followNum: following.toString(),
                        ),
                      ])
                    ],
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 10),
                          title: Text(
                            userInfo['displayName'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('@' + userInfo['userName']),
                        ),
                      ),
                      userInfo['uId'] == myId
                          ? Container()
                          : Row(
                              children: [
                                CustomFollowButton(
                                  onPressed: () {
                                    try {
                                      CloudMethods()
                                          .followUser(myId, userInfo['uId']);
                                      setState(() {
                                        isFollowing
                                            ? followers - 1
                                            : followers++;
                                        isFollowing = !isFollowing;
                                      });
                                    } on Exception catch (e) {
                                      // TODO
                                    }
                                  },
                                  forgroundColor: Colors.white,
                                  backgroundColor: kSecondaryColor,
                                  text: isFollowing ? 'UnFollow' : 'Follow',
                                  icon: isFollowing
                                      ? Icons
                                          .do_not_disturb_on_total_silence_outlined
                                      : Icons.add,
                                ),
                                CustomFollowButton(
                                  forgroundColor: kPrimaryColor,
                                  backgroundColor: kSecondaryColor,
                                  icon: Icons.message,
                                  shape: CircleBorder(
                                    side:
                                        BorderSide(color: Colors.pink.shade200),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                  const Gap(10),
                  userInfo['bio'] == ''
                      ? Container()
                      : Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                    child: Text(userInfo['bio'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: kPrimaryColor))),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: kSecondaryColor.withOpacity(.4),
                                ),
                              ),
                            ),
                          ],
                        ),
                  const Gap(10),
                  TabBar(
                    controller: tabController,
                    tabs: const [
                      Tab(
                        text: "Photos",
                      ),
                      Tab(
                        text: "Posts",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .where('uId', isEqualTo: userInfo['uId'])
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error'),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // dynamic lenSearch = snapshot.data!;
                              return RefreshIndicator(
                                onRefresh: () async {
                                  getUserData();
                                },
                                child: GridView.builder(
                                  itemCount: snapshot.data?.docs.length == 0
                                      ? 1
                                      : snapshot.data?.docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1 / 1.5,
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    dynamic photos =
                                        snapshot.data?.docs.length == 0
                                            ? 1
                                            : snapshot.data?.docs[index];
                                    return snapshot.data?.docs.length == 0
                                        ? Center(
                                            child: ListTile(
                                            title: Text(
                                              'No Posts yet',
                                              style: TextStyle(
                                                  color: kSecondaryColor),
                                            ),
                                            leading: Icon(
                                              Icons
                                                  .not_listed_location_outlined,
                                              color: kWhiteColor,
                                            ),
                                          ))
                                        : Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                  photos['postImage'],
                                                ),
                                              ),
                                            ),
                                            // child: const Column(
                                            //   children: [],
                                            // ),
                                          );
                                  },
                                ),
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .where('uId', isEqualTo: userInfo['uId'])
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error'),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // dynamic lenSearch = snapshot.data!;
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: snapshot.data?.docs.length == 0
                                    ? 1
                                    : snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  dynamic photos =
                                      snapshot.data?.docs.length == 0
                                          ? 1
                                          : snapshot.data?.docs[index];

                                  return snapshot.data?.docs.length == 0
                                      ? Center(
                                          child: ListTile(
                                          title: Text(
                                            'No Posts yet',
                                            style: TextStyle(
                                                color: kSecondaryColor),
                                          ),
                                          leading: Icon(
                                            Icons.not_listed_location_outlined,
                                            color: kWhiteColor,
                                          ),
                                        ))
                                      : Container(
                                          width: double.infinity,
                                          // padding:const EdgeInsets.symmetric(horizontal: 8),
                                          child: PostCard(
                                            item: photos,
                                          ),
                                        );
                                },
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

// ignore: must_be_immutable
class CustomFollowButton extends StatelessWidget {
  final CircleBorder? shape;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color forgroundColor;

  CustomFollowButton({
    super.key,
    this.text = '',
    required this.icon,
    @required this.shape,
    this.onPressed,
    required this.backgroundColor,
    required this.forgroundColor,
  });

  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        // style:ElevatedButton.styleFrom(
        //    foregroundColor:forgroundColor,
        //      backgroundColor:backgroundColor,
        // ),
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => shape),
          foregroundColor:
              MaterialStateColor.resolveWith((states) => forgroundColor),
          backgroundColor:
              MaterialStateColor.resolveWith((states) => backgroundColor),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18)),
            const Gap(5),
            Icon(icon, color: Colors.white)
          ],
        ));
  }
}

class FollowersCard extends StatelessWidget {
  const FollowersCard({
    super.key,
    required this.followNum,
    required this.follow,
  });

  final String followNum;
  final String follow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: kWhiteColor.withOpacity(.4),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          ImageStack(
            imageSource: ImageSource.Asset,
            imageList: const [
              'assets/images/man.png',
              'assets/images/woman.png',
            ],
            imageRadius: 40,
            imageBorderWidth: .5,
            imageBorderColor: Colors.white,
            totalCount: 0,
          ),
          Gap(5),
          Row(
            children: [Text(followNum.toString()), Gap(5), Text(follow)],
          ),
        ],
      ),
    );
  }
}
