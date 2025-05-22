import 'package:flutter/material.dart';
import 'package:railway/authentication/login_page.dart';
import 'package:railway/authentication/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(showSignupPage: toggleScreen,);
    }else {
      return SignupPage(showLoginPage: toggleScreen);
    }
  }
}
