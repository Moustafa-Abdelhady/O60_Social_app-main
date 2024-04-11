import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:o_social_app/models/user_model.dart';
import 'package:o_social_app/pages/chat/chat_page.dart';
import 'package:o_social_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MassengerPage extends StatefulWidget {
  MassengerPage({super.key, this.uId});

  String? uId;

  @override
  State<MassengerPage> createState() => _MassengerPageState();
}

class _MassengerPageState extends State<MassengerPage> {
  String myId = FirebaseAuth.instance.currentUser!.uid;

  bool isLoad = true;
  var userInfo = {};

  @override
  void initState() {
    widget.uId = widget.uId ?? FirebaseAuth.instance.currentUser!.uid;
    Provider.of<UserProvider>(context, listen: false).getDetails();
    getUserData();
    super.initState();
  }

  getUserData() async {
    try {
      var userDetail = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uId ?? myId)
          .get();

      userInfo = userDetail.data()!;

      setState(() {
        isLoad = false;
      });
    } on Exception catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userData = Provider.of<UserProvider>(context).userModel!;
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                  text: 'Messages',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))
            ],
          ),
        ),
        // centerTitle: true,
      ),
      body: Container(
        // color: kWhiteColor,
        // decoration: BoxDecoration(),
        child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('users').get(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return doc['uId'] !=
                              FirebaseAuth.instance.currentUser?.uid
                          ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatPage(uId: doc['email'])),
                                    );
                                  },
                                  child: ListTile(
                                    // leading:CircleAvatar(),
                                    leading: doc['profilePic'] == ""
                                        ? const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/man.png'),
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(doc['profilePic']),
                                          ),
                                    title: Text(doc['displayName']),
                                    subtitle: Text('@' + doc['userName']),
                                  ),
                                ),
                                const Divider(
                                    color: Colors.grey,
                                    indent: 0,
                                    endIndent: 50)
                              ],
                            )
                          : const SizedBox();
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
