import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:railway/toast%20message/toast_message.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _email = TextEditingController();

  Future _resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
          child: Text('Link sent successfully.'),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));
    } on FirebaseAuthException catch (e) {
      ToastMessage.showToast(context, e.message.toString());
    }
  }
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0X6868DEFF),
        title: Text('Forget Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Enter register email and we will sent you a password reset link",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: "Email",
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              onPressed: () {
                if (_email.text.isEmpty) {
                  SnackBarMsg.showSnack(context, 'Please enter an email.');
                } else {
                  _resetPassword();
                }
              },
              color: Color(0X6868DEFF),
              child: Text('Reset Password'),
            )
          ],
        ),
      ),
    );
  }
}
