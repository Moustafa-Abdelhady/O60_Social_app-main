// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/navigation_bar_layout.dart';
import 'package:o_social_app/pages/authantication/register_page.dart';
import 'package:o_social_app/services/auth.dart';
// import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  signIn() async {
    try {
      String loginRes = await AuthMethods()
          .signIn(email: emailCont.text, password: passwordCont.text);
      SnackBar snackbar = SnackBar(
        content: Center(child: Text(loginRes.toString())),
      );
      if (loginRes == "Success") {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>const NavBarLayout()),
            (route) => false);
      } else if (loginRes == "Please enter all fields" || loginRes == null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } on Exception catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/images/svg/mobile-app-svgrepo-com.svg',
                height: 300,
                colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
              ),
            ),
            // const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('O',
                    style: TextStyle(
                        fontSize: 26,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold)),
                const Text('60',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Gap(15),
            TextField(
              controller: emailCont,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                fillColor: kWhiteColor,
                filled: true,
                prefixIcon: const Icon(Icons.email),
                hintText: 'Enter Mail',
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(16)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const Gap(10),
            TextField(
              controller: passwordCont,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                fillColor: kWhiteColor,
                filled: true,
                prefixIcon: const Icon(Icons.password),
                hintText: 'Enter Password',
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(16)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const Gap(20),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  onPressed: () {
  
                    if (emailCont.text.isEmpty|| emailCont.text.contains('@') & passwordCont.text.isEmpty || passwordCont.text.length < 8){
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                   content: Center(child: Text('Please enter an valid Mail and password')),
                       ));
                    } else {
                       signIn();
                          }
                    
                  },
                  child: Text(
                    'login'.toUpperCase(),
                    style: TextStyle(color: kWhiteColor),
                  ),
                ),
              )
            ]),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Dont have an account?',
                ),
                const Gap(15),
                GestureDetector(
                  onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                      (route) => false),
                  child: Text(
                    'Register  ',
                    style: TextStyle(color: kPrimaryColor , fontWeight:FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
