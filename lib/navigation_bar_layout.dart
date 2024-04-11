import 'package:flutter/material.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/pages/add_page.dart';
import 'package:o_social_app/pages/home_page.dart';
import 'package:o_social_app/pages/profile_page.dart';
import 'package:o_social_app/pages/search_page.dart';
import 'package:o_social_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class NavBarLayout extends StatefulWidget {
  const NavBarLayout({super.key});

  @override
  State<NavBarLayout> createState() => _NavBarLayoutState();
}

class _NavBarLayoutState extends State<NavBarLayout> {
  int currentIndex = 0;
  PageController pageCont = PageController();

    @override
  void initState() {
        Provider.of<UserProvider>(context, listen: false).getDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<UserProvider>(context).isLoad? const Scaffold(body: Center(child: CircularProgressIndicator()),): Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageCont,
        children:  [
          const HomePage(),
          const AddPage(),
          const SearchPage(),
          ProfilePage(),
        ],
        onPageChanged: (value) => setState(() {
          currentIndex = value;
        }),
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        indicatorColor: kWhiteColor.withOpacity(.6),
        backgroundColor: Colors.white.withOpacity(.7),
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
            pageCont.jumpToPage(value);
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            selectedIcon: Icon(
              Icons.home,
              color: kPrimaryColor,
            ),
            label: "Home",
          ),
          NavigationDestination(
              icon: const Icon(Icons.add),
              selectedIcon: Icon(Icons.add, color: kPrimaryColor),
              label: "Add"),
          NavigationDestination(
              icon: const Icon(Icons.search),
              selectedIcon: Icon(Icons.search, color: kPrimaryColor),
              label: "Search"),
          NavigationDestination(
              icon: const Icon(Icons.person),
              selectedIcon: Icon(Icons.person, color: kPrimaryColor),
              label: "Profile"),
        ],
      ),
    );
  }
}




//  BottomNavigationBar(
//         currentIndex: currentIndex,
//         items: const [
//           BottomNavigationBarItem(label: "", icon: Icon(Icons.home)),
//           BottomNavigationBarItem(label: "", icon: Icon(Icons.search)),
//           BottomNavigationBarItem(label: "", icon: Icon(Icons.person)),
//         ],
//         onTap: (value) {
//           setState(() {
//             currentIndex = value;
//           });
//         },
//       ),