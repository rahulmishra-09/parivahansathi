import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/dashboard/dashboard.dart';
import 'package:railway/database/firestore_service.dart';
import 'package:railway/main%20page/main_page.dart';
import 'package:railway/profile/change_password.dart';
import 'package:railway/profile/my_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirestoreService firestoreService = FirestoreService();
  bool isLoading = true;
  String name = '';
  String email = '';

  void _logOut() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(),
              title: Text(
                'Exit Alert',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              content: Text('Are you sure you want to logout?'),
              actions: [
                InkWell(onTap: () => Navigator.pop(context), child: Text('No')),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();

                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                          (route) => false);
                    },
                    child: Text('Yes')),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      DocumentSnapshot? doc = await firestoreService.getUserDetails();
      if (doc != null && doc.exists) {
        setState(() {
          name = doc['name'] ?? "Name";
          email = doc['email'] ?? "Email";
          isLoading = false;
        });
      } else {
        isLoading = false;
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Dashboard(),
                fullscreenDialog: true,
              ));
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        title: Text(
          'P R O F I L E',
          style: GoogleFonts.dmSans(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.maxFinite,
              color: Colors.deepOrangeAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.deepOrangeAccent,
                    child: Icon(
                      CupertinoIcons.profile_circled,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  isLoading
                      ? CircularProgressIndicator(
                          color: Colors.deepOrangeAccent, 
                          strokeWidth: 4.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.merienda(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            Text(
                              email,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        )
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyProfile(),
                fullscreenDialog: true,
              )),
              child: Container(
                color: Colors.grey[200],
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                  ),
                  title: Text(
                    'My Profile',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  // style: ListTileStyle.list,
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangePassword(),
                  fullscreenDialog: true,
                ));
              },
              child: Container(
                color: Colors.grey[200],
                child: ListTile(
                  leading: Icon(
                    Icons.password,
                  ),
                  title: Text(
                    'Change Password',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  // style: ListTileStyle.list,
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            GestureDetector(
              onTap: _logOut,
              child: Container(
                color: Colors.grey[200],
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: Text(
                    'Logout',
                    //style: TextStyle(color: Colors.black),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  style: ListTileStyle.list,
                ),
              ),
            ),
            const SizedBox(height: 2,),
               Center(
                child: Container(
                  height: 500,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pages_design.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
