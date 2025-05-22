import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MaterialApp(
      home: DemoTestingPage(),
      debugShowCheckedModeBanner: false,
    ));

class DemoTestingPage extends StatefulWidget {
  const DemoTestingPage({super.key});

  @override
  State<DemoTestingPage> createState() => _DemoTestingPageState();
}

class _DemoTestingPageState extends State<DemoTestingPage> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _cnfPassword = TextEditingController();
  final _phone = TextEditingController();
  final _dobController = TextEditingController();
  final _address = TextEditingController();
  bool _obsTxt = true;
  String? gender;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstName,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: 'First name',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your first name.";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _lastName,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: 'Last name',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your last name.";
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
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    obscureText: _obsTxt,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      counterText: '',
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
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm password',
                      counterText: '',
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
                          onTap: () {},
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
                    onPressed: () {},
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
                        onTap: () {},
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
      ),
    );
  }
}
