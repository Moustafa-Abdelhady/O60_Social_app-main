import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/pages/authantication/login_page.dart';
import 'package:o_social_app/services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController displaycont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  register() async {
    try {
      String response = await AuthMethods().signUp(
          email: emailCont.text,
          password: passwordCont.text,
          userName: userNameCont.text,
          display: displaycont.text);

      SnackBar snackbar = SnackBar(
        content: Center(child: Text(response.toString())),
      );

      if (response == "Success") {
        // ignore: use_build_context_synchronously
        return ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else {
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
      body: Center(
        child: SingleChildScrollView(
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
              const Gap(8),
              const Text('Welcome Back', style: TextStyle(fontSize: 16)),

              const Gap(15),
              TextField(
                controller: displaycont,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  fillColor: kWhiteColor,
                  filled: true,
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Enter Name',
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
                controller: userNameCont,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'User Username',
                  fillColor: kWhiteColor,
                  filled: true,
                  prefixIcon: const Icon(Icons.contact_mail),
                  hintText: 'Enter Username',
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
                      register();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false);
                    },
                    child: Text(
                      'Register'.toUpperCase(),
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
                    'already have an account?',
                  ),
                  const Gap(15),
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
