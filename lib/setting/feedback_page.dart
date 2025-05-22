import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/toast%20message/toast_message.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _selectStar = 1;
  String? remarks;
  final _remarks = TextEditingController();

  void _validation() async {
    if (remarks == null) {
      ToastMessage.showToast(context, 'Select a reason.');
    } else if (_remarks.text.isEmpty) {
      ToastMessage.showToast(context, 'Enter a remark.');
      return;
    }
    String feedback;
    if (_selectStar == 1) {
      feedback = 'Poor';
    } else if (_selectStar == 2 || _selectStar == 3) {
      feedback = 'Average';
    } else if (_selectStar == 4) {
      feedback = 'better';
    } else {
      feedback = 'Excellent';
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      SnackBarMsg.showSnack(context, 'User not loggedin!!');
    }

    String userEmail = user!.email!;
    CollectionReference feedbaceCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('feedback');

    await feedbaceCollection.add({
      'user': userEmail,
      'rating': _selectStar,
      'feedbackresult': feedback,
      'category': remarks,
      'remark': _remarks.text.trim(),
      'timestamp': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(
        child: Text(
          'Feedback submitted successfully...',
          style: GoogleFonts.merienda(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ));

    setState(() {
      _remarks.clear();
      remarks = null;
      _selectStar = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          'F E E D B A C K',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Please rate us to improve our experience',
                    style:
                        GoogleFonts.merienda(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _selectStar = index + 1;
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            color: index < _selectStar
                                ? Colors.deepOrange
                                : Colors.grey[700],
                            size: 50,
                          ),
                        );
                      })),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: DropdownButtonFormField(
                      value: remarks,
                      onChanged: (value) {
                        setState(() {
                          remarks = value;
                        });
                      },
                      items: [
                        'Design',
                        'Login',
                        'Registration',
                        'Payment Issue',
                        'Others'
                      ]
                          .map((remark) => DropdownMenuItem(
                                value: remark,
                                child: Text(remark),
                              ))
                          .toList(),
                      decoration: InputDecoration(
                        hintText: "Select Rating Criteria",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 180,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: TextField(
                            controller: _remarks,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.center,
                            maxLines: null,
                            maxLength: 100,
                            decoration: InputDecoration(
                              hintText: 'Remarks',
                              counterText: '',
                              hintStyle: GoogleFonts.merienda(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              "SKIP",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: _validation,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              "SUBMIT",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
