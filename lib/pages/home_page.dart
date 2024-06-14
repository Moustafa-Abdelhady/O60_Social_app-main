import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/pages/chat/massenger.dart';
import 'package:o_social_app/widgets/post_home_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    late Stream<QuerySnapshot> postsStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MassengerPage()),
                );
              },
              icon: const Icon(Icons.message),
            ),
          ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: postsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot document = documents[index];
                final Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return PostCard(
                  item: document,
                  // userPic: userIn,
                );
                // FutureBuilder(
                //   future: FirebaseFirestore.instance
                //       .collection('users')
                //       .doc(document['uId'])
                //       .get(),
                //   builder:
                //       (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                //     if (userSnapshot.connectionState ==
                //         ConnectionState.waiting) {
                //       return const Center(child: Text(''));
                //     }
                //     if (userSnapshot.hasError) {
                //       return Text('Error: ${userSnapshot.error}');
                //     }
                //     final userIn = userSnapshot.data!.data();
                //     return PostCard(
                //       item: document,
                //       userPic: userIn,
                //     );
                //   },
                // );

                // return const Text('lol');
              },
            );
          }),
    );
  }
}
