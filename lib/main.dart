import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:o_social_app/firebase_options.dart';
import 'package:o_social_app/navigation_bar_layout.dart';
import 'package:o_social_app/pages/authantication/login_page.dart';
import 'package:o_social_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=> UserProvider() ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            appBarTheme:const AppBarTheme(surfaceTintColor: Colors.white)),
        // make stream builder to check if user has logedin makes him going to homepage
        //and if he new in app makes him going to login page
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const NavBarLayout();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
