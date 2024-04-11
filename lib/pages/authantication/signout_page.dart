import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:o_social_app/pages/authantication/login_page.dart';

class SignOut extends StatefulWidget {
  const SignOut({super.key});

  @override
  State<SignOut> createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  final FirebaseAuth _outAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(_outAuth.currentUser!.email.toString()),
            ElevatedButton(
              onPressed: () async {
                await _outAuth.signOut();
                try {
  Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false);
} on Exception catch (e) {
     print(e.toString());
}
              },
              child: const Text('signout'),
            ),
          ],
        ),
      ),
    );
  }
}
