import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/authentication/forget_password.dart';
import 'package:railway/dashboard/dashboard.dart';
import 'package:railway/toast%20message/toast_message.dart';
import 'package:railway/widgets/connection.dart';
import 'package:railway/widgets/loading_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showSignupPage;
  const LoginPage({super.key, required this.showSignupPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  Connection conn = Connection();
  bool _obsTxt = true;

  bool validEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  void _loginUser() {
    String email = _email.text;
    if (_email.text.isEmpty) {
      SnackBarMsg.showSnack(context, 'Please enter your email.');
    } else if (!validEmail(email)) {
      SnackBarMsg.showSnack(context, 'Please enter valid email.');
    } else if (_password.text.isEmpty) {
      SnackBarMsg.showSnack(context, 'Please enter your password.');
    } else {
      print('Successfully run');
      loginUser();
    }
  }

  Future loginUser() async {
    try {
      showDialog(
          context: context,
          builder: (context) => LoadingPage(message: 'Allowing to login...'));

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      if(!context.mounted) return;
      Navigator.pop(context);


      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));

    } on FirebaseAuthException catch(e) {
      Navigator.of(context).pop();
      String errMsg;

      if (e.code == 'user-not-found') {
        errMsg = 'No user found for this email.';
      } else if(e.code == 'wrong-password') {
        errMsg = 'Incorrect password. Try again.';
      } else{
        errMsg = 'Login failed. Please try again.';
      }
      ToastMessage.showToast(context, errMsg);
    }
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('assets/rail.png')),
                  ),
                ),
                Text(
                  'PARIVAHAN SATHI',
                  style: GoogleFonts.merienda(
                      fontSize: 34,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  'Please login with your personal info!',
                  style: GoogleFonts.merienda(),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    suffix: InkWell(
                        onTap: (){
                          _email.text = '';
                        },
                        child: Icon(
                          CupertinoIcons.multiply_circle_fill, size: 20,)),
                    prefixIcon: Icon(CupertinoIcons.mail_solid),
                    focusedBorder: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _password,
                  decoration: InputDecoration(
                    hintText: "Password",
                    counterText: '',
                    prefixIcon: Icon(CupertinoIcons.padlock_solid),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obsTxt = !_obsTxt;
                          });
                        },
                        icon: Icon(_obsTxt
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    focusedBorder: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(),
                  ),
                  maxLength: 10,
                  obscureText: _obsTxt,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                        fullscreenDialog: true
                        ));
                      },
                      child: Text(
                        'Forget Password',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showSignupPage,
                      child: Text(
                        'Change/Register user',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          shape: CircleBorder(),
                          elevation: 0,
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
