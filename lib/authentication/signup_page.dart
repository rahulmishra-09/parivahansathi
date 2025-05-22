import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:railway/database/firestore_service.dart';
import 'package:railway/toast%20message/toast_message.dart';
import 'package:railway/widgets/loading_page.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignupPage({super.key, required this.showLoginPage});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _cnfPassword = TextEditingController();
  final _phone = TextEditingController();
  final _dobController = TextEditingController();
  final _address = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  bool _obsTxt = true;
  String? gender;
  final _formKey = GlobalKey<FormState>();

  void registerUser() async {
    try {
      showDialog(
          context: context,
          builder: (context) => LoadingPage(message: 'Registering user...'));
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(), password: _password.text.trim());

      if(!context.mounted) return;
      Navigator.pop(context);

      await firestoreService.addUser(
          _name.text.trim(),
          _email.text.trim(),
          _phone.text.trim(),
          _dobController.text.trim(),
          gender.toString(),
          _address.text.trim());
    } catch (e) {
      ToastMessage.showToast(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          'REGISTER DETAILS',
          style: GoogleFonts.merienda(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
                child: TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    suffix: InkWell(
                        onTap: () {
                          _name.text = '';
                        },
                        child: Icon(
                          CupertinoIcons.multiply_circle_fill,
                          size: 20,
                        )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(width: 1.6)
                    ),
                    enabledBorder: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your name.";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    suffix: InkWell(
                        onTap: () {
                          _email.text = '';
                        },
                        child: Icon(
                          CupertinoIcons.multiply_circle_fill,
                          size: 20,
                        )),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your email.";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
                child: TextFormField(
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obsTxt,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obsTxt = !_obsTxt;
                          });
                        },
                        icon: Icon(
                            _obsTxt ? Icons.visibility : Icons.visibility_off)),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your password.";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters long.";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
                child: TextFormField(
                  controller: _cnfPassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your confirm password.";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
                child: TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    counterText: '',
                    suffix: InkWell(
                        onTap: () {
                          _phone.text = '';
                        },
                        child: Icon(
                          CupertinoIcons.multiply_circle_fill,
                          size: 20,
                        )),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your phone.";
                    } else if (value.length < 10) {
                      return "Enter valid phone number";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dobController,
                        keyboardType: TextInputType.datetime,
                        maxLength: 10,
                        readOnly: true,
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: 'Date of birth',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your Date of birth.";
                          } else {
                            return null;
                          }
                        },
                        onTap: _selectDate,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        items: ['Male', 'Female', 'Other']
                            .map((gender) => DropdownMenuItem(
                                value: gender, child: Text(gender)))
                            .toList(),
                        decoration: InputDecoration(
                          hintText: "Gender",
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                        ),
                        validator: (genType) {
                          if (genType == null) {
                            return "Select your gender";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
                child: TextFormField(
                  controller: _address,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Address',
                    suffix: InkWell(
                        onTap: () {
                          _address.text = '';
                        },
                        child: Icon(
                          CupertinoIcons.multiply_circle_fill,
                          size: 20,
                        )),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your address";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 100),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I am a member! ",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0XFF032030),
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(
                        "Login now",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime today = DateTime.now();
    DateTime valYear = DateTime(today.year - 18, today.month, today.day);

    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: valYear,
        firstDate: DateTime(1950),
        lastDate: valYear);
    if (picked != null) {
      _dobController.text = DateFormat('dd/MM/yyy').format(picked);
    }
  }

  bool _checkPassword() {
    if (_password.text == _cnfPassword.text) {
      return true;
    } else {
      return false;
    }
  }

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      if (_checkPassword()) {
        print('Successfully run');
        registerUser();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
                child: Text(
              'Password mismatched',
              style: TextStyle(color: Colors.white),
            )),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
