import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:railway/database/firestore_service.dart';
import 'package:railway/profile/profile.dart';
import 'package:railway/toast%20message/toast_message.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool isReadOnly = true;
  final name = TextEditingController();
  final dobController = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  User? currentUser;

  Future<void> _printDetails() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    try {
      DocumentSnapshot? doc = await firestoreService.getUserDetails();
      if (doc != null) {
        setState(() {
          name.text = doc['name'];
          dobController.text = doc['dob'];
          phone.text = doc['phone'];
          address.text = doc['address'];
        });
      } else {
        Center(
          child: Text(
            'No details found!',
            style:
                GoogleFonts.merienda(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      }
    } catch (e) {
      ToastMessage.showToast(context, e.toString());
    }
  }

  Future<void> updateDetails() async {
    if (currentUser == null) return;

    try {
      await firestoreService.updateData(currentUser!.email!, {
        'name': name.text.trim(),
        'dob': dobController.text.trim(),
        'phone': phone.text.trim(),
        'address': address.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Center(
        child: Text(
          'Details updated successfully!!',
          style: GoogleFonts.merienda(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      )));
    } catch (e) {
      ToastMessage.showToast(context, '$e');
    }
  }

  @override
  void initState() {
    super.initState();
    _printDetails();
  }

  void _actionPressed() {
    if (!isReadOnly) {
      updateDetails();
    }
    setState(() {
      isReadOnly = !isReadOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Profile(), fullscreenDialog: true));
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        title: Text(
          'M Y  P R O F I L E',
          style: GoogleFonts.dmSans(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: TextButton(
                onPressed: _actionPressed,
                child: Text(
                  isReadOnly ? 'Edit' : 'Save',
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          _textField(name, "Name"),
          _textField(dobController, "Date of birth",
              onTap: _selectDate, readOnly: true),
          _textField(phone, 'Phone'),
          _textField(address, 'Address'),
        ],
      ),
    );
  }

  void _selectDate() async {
    if (isReadOnly) return;
    DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        initialDate: DateTime(2000, 1, 1));

    if (picked != null) {
      final age = DateTime.now().year - picked.year;
      if (age < 18) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
          child: Text('Age must greater than 18'),
        )));
        return;
      }
      setState(() {
        dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _textField(TextEditingController controller, String hint,
      {bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.characters,
        readOnly: isReadOnly || readOnly,
        decoration: InputDecoration(
          hintText: hint,
          focusedBorder: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(),
        ),
        onTap: onTap,
      ),
    );
  }
}
