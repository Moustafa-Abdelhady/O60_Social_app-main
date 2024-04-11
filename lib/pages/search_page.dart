import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/pages/profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key,});

  

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchCont = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    late Future<QuerySnapshot> usersData = FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: searchCont.text)
        .get();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SearchBar(
              controller: searchCont,
              onChanged: (value) {
                setState(() {
                  searchCont.text = value;
                });
              },
              trailing: [
                Icon(
                  Icons.search,
                  color: kSecondaryColor,
                ),
              ],
              hintText: 'Search by username ',
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              elevation: MaterialStateProperty.resolveWith((states) => 1),
              shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: kPrimaryColor)),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: usersData,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      dynamic lenSearch = snapshot.data!;
                      return ListView.builder(
                        itemCount: lenSearch.docs.length,
                        itemBuilder: (context, index) {
                          dynamic userData = lenSearch.docs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  ProfilePage(uId:userData['uId'])),
                              );
                            },
                            child: ListTile(
                              // leading:CircleAvatar(),
                              leading: userData['profilePic'] == ""
                                  ? const CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/images/man.png'),
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(userData['profilePic']),
                                    ),
                              title: Text(userData['displayName']),
                              subtitle: Text('@' + userData['userName']),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
