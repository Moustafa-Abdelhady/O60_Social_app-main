// import 'package:chat_app/pages/cubit/chat_cubit/chat_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';

import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/models/user_model.dart';
import 'package:o_social_app/pages/chat/chat_buble.dart';

import 'package:o_social_app/providers/user_provider.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/message.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, this.uId});

  // static String id = 'ChatPage';
  final uId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

final chatRoomId = const Uuid().v1();

class _ChatPageState extends State<ChatPage> {
// make instance from firestore

  List<Message> messagesList = [];

//  make reference from collection in my firebase
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  TextEditingController searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    print('...${widget.uId}');
    UserModel userData = Provider.of<UserProvider>(context).userModel!;
    final currUser = FirebaseAuth.instance.currentUser!.email;

    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: 'O',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
              const TextSpan(
                  text: '60',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messages
                  .orderBy('createdAt', descending: true)
                  .where('fromId', whereIn: [currUser]).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Say Hey'),
                          Gap(10),
                          Icon(
                            Icons.waving_hand,
                            color: Colors.amber,
                          )
                        ]),
                  );
                }

                List<Message> messagesList = [];

                if (snapshot.hasData) {
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    messagesList.add(Message.fromJsson(snapshot.data!.docs[i]));
                  }
                }

                // for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
                //   messagesList.add(Message.fromJsson(doc));
                // }

                // messagesList = snapshot.data!.docs
                //     .map((doc) => Message.fromJsson(doc))
                //     .toList();

                // List<Message> filteredMessages = messagesList
                //     .where((message) => message.toId == widget.uId)
                //     .toList();
                // print('OO${filteredMessages.length}');

                // for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
                //   filteredMessages.add(Message.fromJsson(doc));
                // }

                return ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      // var mes = messagesList
                      //     .map((e) => e.toId == widget.uId)
                      //     .toList()
                      //     .cast<Message>();

                      // messagesList.map((e) => null)
                      print('.......${messagesList[index].toId}');
                      print('****${messagesList[index].fromId}');
                      print('0000${currUser}');
                      return messagesList[index].toId == widget.uId
                          // email
                          ? OtherChatBuble(
                              message: messagesList[index],
                              id: messagesList[index].fromId,
                            )
                          : ChatBuble(
                              message: messagesList[index],
                              id: widget.uId,
                            );
                    });
              },
            ),
          ),
          // Expanded(
          //   child: BlocBuilder<ChatCubit, ChatState>(
          //     builder: (context, state) {
          //       var messagesList =
          //           BlocProvider.of<ChatCubit>(context).messagesList;
          //       return ListView.builder(
          //           reverse: true,
          //           controller: scrollController,
          //           itemCount: messagesList.length,
          //           itemBuilder: (context, index) {
          //             return messagesList[index].id == "" //email
          //                 ? ChatBuble(
          //                     message: messagesList[index],
          //                     id: messagesList[index].id,
          //                   )
          //                 : otherChatBuble(
          //                     message: messagesList[index],
          //                     id: messagesList[index].id,
          //                   );
          //           });
          //     },
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: kPrimaryColor.withOpacity(0.1)),
            ]),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: searchController,
                  onSubmitted: (data) {
                    messages.add({
                      'message': data,
                      'createdAt': DateTime.now().toString().substring(10, 16),
                      'fromId': currUser,
                      'toId': widget.uId,
                    });
                    // CloudMethods().sendMessage(
                    //     message: data, email: currUser!, toEmail: widget.uId);
                    print(searchController);
                    searchController.clear();
                    scrollController.animateTo(
                        scrollController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.send, color: kPrimaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    hintText: 'Send Message ',
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        gapPadding: .6,
                        borderSide: BorderSide(color: kPrimaryColor)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
    // } else {
    //   return Center(
    //     child: CircularProgressIndicator(
    //       backgroundColor: Colors.blue[300],
    //     ),
    //   );
    // }
    // },
    // );
  }
}
