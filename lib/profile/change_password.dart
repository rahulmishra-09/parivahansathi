import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final cnfPassword = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void _showSnack(String txt, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: Center(
          child: Text(
            txt,
            style: GoogleFonts.merienda(color: Colors.white),
          ),
        )));
  }

  Future<void> _changePassword() async{
    if(!_formKey.currentState!.validate()) return;
    if(!_checkPassword()) {
      _showSnack('New passwords do not match', Colors.red);
      return;
    } 
    User? user = auth.currentUser;

    if(user!= null && user.email != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, 
        password: oldPassword.text.trim());

    try {
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword.text.trim());

      _showSnack('Password changed successfully!!', Colors.green);

      oldPassword.clear();
      newPassword.clear();
      cnfPassword.clear();

    } on FirebaseAuthException catch (e) {
      _showSnack(e.message ?? 'Failed to change password!!', Colors.red);
    }
    }
  }

  bool _checkPassword() {
    if (newPassword.text.trim() == cnfPassword.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    oldPassword.dispose();
    newPassword.dispose();
    cnfPassword.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          'Change Password',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: oldPassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Old Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Old Password";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: newPassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "New Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter New Password";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: cnfPassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Confirm Password";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  animationDuration: Duration(milliseconds: 400),
                ),
                child: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
