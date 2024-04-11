import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/models/post_model.dart';
import 'package:o_social_app/models/user_model.dart';
import 'package:o_social_app/pages/chat/chat_page.dart';
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
    // CollectionReference posts = FirebaseFirestore.instance.collection('posts').snapshots();
    late Stream<QuerySnapshot> postsStream =
        FirebaseFirestore.instance.collection('posts').orderBy('date',descending: true).snapshots();
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
                              MaterialPageRoute(
                                  builder: (context) =>
                                        MassengerPage()),
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

            // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot document = documents[index];
                final Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return PostCard(item: document);
                // return const Text('lol');
              },
            );
          }),
    );
  }
}




    /////////// Main solve to home page

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:o_social_app/constants/colors/app_colors.dart';
// import 'package:o_social_app/models/post_model.dart';
// import 'package:o_social_app/models/user_model.dart';
// import 'package:o_social_app/widgets/post_home_card.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     // CollectionReference posts = FirebaseFirestore.instance.collection('posts').snapshots();
//     Stream<QuerySnapshot> posts = FirebaseFirestore.instance.collection('posts').snapshots();
//     return Scaffold(
//       appBar: AppBar(
//           centerTitle: true,
//           title: Text.rich(
//             TextSpan(
//               children: [
//                 TextSpan(
//                     text: 'O',
//                     style: TextStyle(
//                         color: kPrimaryColor,
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold)),
//                 const TextSpan(
//                     text: '60',
//                     style: TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.bold))
//               ],
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.message),
//             ),
//           ]),
//       body:StreamBuilder(
//           stream: posts,
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text('Error'),
//               );
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

//             return ListView.builder(
//               itemCount: snapshot.data.docs.length,
//               itemBuilder: (context, index) {
//                 dynamic data = snapshot.data;
//                 dynamic item = data.docs[index];
//                 return PostCard(item:item);
//                 // return const Text('lol');
//               },
//             );
//           }),
//     );
//   }
// }
