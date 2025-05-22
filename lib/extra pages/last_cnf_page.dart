import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:railway/booking%20ticket/transaction_page.dart';
import 'package:railway/extra%20pages/gen_ticket.dart';
import 'package:railway/toast%20message/toast_message.dart';

class LastCnfPage extends StatefulWidget {
  final String trainNo,
      trainName,
      fromStation,
      destination,
      boardingStation,
      boardingTime,
      journeyDate,
      transactionId,
      upiId,
      irctcUname,
      email,
      phone;

  final int fare;

  final List<Map<String, dynamic>> productList;
  const LastCnfPage({
    super.key,
    required this.trainNo,
    required this.trainName,
    required this.fromStation,
    required this.destination,
    required this.boardingStation,
    required this.boardingTime,
    required this.journeyDate,
    required this.transactionId,
    required this.upiId,
    required this.irctcUname,
    required this.email,
    required this.phone,
    required this.fare,
    required this.productList,
  });

  @override
  State<LastCnfPage> createState() => _LastCnfPageState();
}

class _LastCnfPageState extends State<LastCnfPage> {
  final _formKey = GlobalKey<FormState>();
  final irctcPassword = TextEditingController();
  final roomController = TextEditingController();
  final villageController = TextEditingController();
  final landmarkController = TextEditingController();
  final pincodeController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final droproomController = TextEditingController();
  final dropVillageController = TextEditingController();
  final dropLandmarkController = TextEditingController();
  final dropPincodeController = TextEditingController();
  final dropDistrictController = TextEditingController();
  final dropStateController = TextEditingController();
  bool isExpanded = false;
  String? selectedPostoffice;
  String? selectedDropPostOffice;
  List<String> dropPoList = [];
  List<String> postofficeList = [];
  bool isLoading = false;
  bool isNewLoading = false;
  bool passwordVerify = false;
  bool isVerifying = false;
  bool pincodeVerified = false;
  bool dropPincodeVerified = false;

  Future<void> fetchPincode(String pincode) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('https://api.postalpincode.in/pincode/$pincode');
    final response = await http.get(url);

    await Future.delayed(Duration(seconds: 2));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(data);

      if (data.isNotEmpty && data[0]['Status'] == "Success") {
        var postData = data[0]['PostOffice'];

        if (postData != null && postData is List && postData.isNotEmpty) {
          setState(() {
            districtController.text = postData[0]['District'] ?? '';
            stateController.text = postData[0]['State'] ?? '';
            selectedPostoffice = null;
            postofficeList = postData
                .map<String>((post) => post['Name'].toString())
                .toList();
                pincodeVerified = true;
          });
        } else {
          print("No PostOffice found");
          SnackBarMsg.showSnack(
              context, 'No Postoffice found for this $pincode');
        }
      } else {
        print("Pincode not found");
        SnackBarMsg.showSnack(context, 'Pincode Not Found');
      }
    } else {
      print(response.statusCode);
      SnackBarMsg.showSnack(context, 'Error to fetching Pincode data');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDropPincode(String pincode) async {
    setState(() {
      isNewLoading = true;
    });
    final url = Uri.parse('https://api.postalpincode.in/pincode/$pincode');
    final response = await http.get(url);

    await Future.delayed(Duration(seconds: 2));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(data);

      if (data.isNotEmpty && data[0]['Status'] == "Success") {
        var postData = data[0]['PostOffice'];

        if (postData != null && postData is List && postData.isNotEmpty) {
          setState(() {
            dropDistrictController.text = postData[0]['District'] ?? '';
            dropStateController.text = postData[0]['State'] ?? '';
            selectedDropPostOffice = null;
            dropPoList =
                postData.map((post) => post['Name'].toString()).toList();
                 dropPincodeVerified = true;
          });
        }
      } else {
        print('Pincode not found');
        SnackBarMsg.showSnack(context, 'Pincode Not Found');
      }
    } else {
      print(response.statusCode);
      SnackBarMsg.showSnack(context, 'Error to fetching Pincode data');
    }
    setState(() {
      isNewLoading = false;
    });
  }

  void backAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            title: Text(
              'Exit Alert!',
              style: GoogleFonts.merienda(color: Colors.red),
            ),
            content: Text(
              'Are you sure you want to go back? If you exit now, your payment will be canceled, and this action cannot be undone.',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionPage(
                              trainNo: widget.trainNo,
                              trainName: widget.trainName,
                              fromStation: widget.fromStation,
                              destination: widget.destination,
                              boardingStation: widget.boardingStation,
                              boardingTime: widget.boardingTime,
                              journeyDate: widget.journeyDate,
                              irctcUname: widget.irctcUname,
                              email: widget.email,
                              phone: widget.phone,
                              fare: widget.fare,
                              productList: widget.productList)),
                      (route) => route.isFirst,
                    );
                  },
                  child: Text('Exit', style: TextStyle(color: Colors.red)))
            ],
          );
        });
  }

  final irctcPasswordFormat = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%*!])[A-Za-z\d@#$%*!]{8,16}$');

  Future<void> saveBookingData(String updatedDate) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }
      String userEmail = user.email!;
      DocumentReference docReference =
          FirebaseFirestore.instance.collection('users').doc(userEmail);

      CollectionReference bookings = docReference.collection('bookings');
      await bookings.add({
        'trainNo': widget.trainNo,
        'currentUser': userEmail,
        'trainName': widget.trainName,
        'fromStation': widget.fromStation,
        'destination': widget.destination,
        'boardingStation': widget.boardingStation,
        'boardingTime': widget.boardingTime,
        'bookingDate': formatDate,
        'journeyDate': widget.journeyDate,
        'transactionId': widget.transactionId,
        'deliveryDate': updatedDate,
        'upiId': widget.upiId,
        'irctcUname': widget.irctcUname,
        'email': widget.email,
        'phone': widget.phone,
        'fare': widget.fare,
        'productList': widget.productList,
        'pickupAddress': {
          'room': roomController.text.trim(),
          'village': villageController.text.trim(),
          'landmark': landmarkController.text.trim(),
          'pincode': pincodeController.text.trim(),
          'district': districtController.text.trim(),
          'state': stateController.text.trim(),
          'postoffice': selectedPostoffice,
        },
        'dropAddress': {
          'room': droproomController.text.trim(),
          'village': dropVillageController.text.trim(),
          'landmark': dropLandmarkController.text.trim(),
          'pincode': dropPincodeController.text.trim(),
          'district': dropDistrictController.text.trim(),
          'state': dropStateController.text.trim(),
          'postoffice': selectedDropPostOffice,
        },
        'timestamp': Timestamp.now(),
      });
      print('Data is saved!!');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  String formatDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    pincodeController.addListener(
      () {
        setState(() {
          pincodeVerified = false;
        });
      },
    );
    dropPincodeController.addListener(() {
      dropPincodeVerified = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String cleanDate = widget.journeyDate.split(' ')[0];
    DateTime dateParse = DateFormat('dd-MM-yyyy').parse(cleanDate);
    DateTime delDate = dateParse.add(Duration(days: 5));
    String updatedDate = DateFormat('dd-MM-yyyy').format(delDate);

    var textStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);
    var dataStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[800]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading:
            IconButton(onPressed: backAlert, icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          'Confirmation Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              '₹ ${widget.fare}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 18),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trainName,
                          style: textStyle,
                        ),
                        Column(
                          children: [
                            Text(
                              'Pickup Date',
                              style: dataStyle,
                            ),
                            Text(
                              widget.boardingTime,
                              style: dataStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '# ${widget.trainNo}',
                          style: dataStyle,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Text(
                            isExpanded ? 'Hide details ▲' : 'More details ▼',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text('Boarding Station'),
                              Text(widget.fromStation),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Destination Station'),
                              Text(widget.destination),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text('Transaction Id'),
                              Text(widget.transactionId),
                            ],
                          ),
                          Column(
                            children: [
                              Text('UPI Id'),
                              Text(widget.upiId),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
                Divider(
                  color: Colors.black,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('IRCTC Username: '),
                        Text(widget.irctcUname),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Email Address: '),
                        Text(widget.email),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Phone Number: '),
                        Text(widget.phone),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IRCTC Password',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: irctcPassword,
                            decoration: InputDecoration(
                              hintText: "IRCTC Password",
                              suffixIcon: isVerifying
                                  ? Padding(
                                      padding: EdgeInsets.all(10),
                                      child: CircularProgressIndicator(
                                        color: Colors.green,
                                        strokeWidth: 4,
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          isVerifying = true;
                                        });

                                        await Future.delayed(
                                            Duration(seconds: 2));

                                        String password =
                                            irctcPassword.text.trim();
                                        if (password.isEmpty) {
                                          ToastMessage.showToast(
                                              context, 'Enter Password first!');
                                        } else if (!irctcPasswordFormat
                                            .hasMatch(password)) {
                                          ToastMessage.showToast(
                                              context, 'Enter valid Password');
                                        } else {
                                          setState(() {
                                            passwordVerify = true;
                                          });
                                        }
                                        setState(() {
                                          isVerifying = false;
                                        });
                                      },
                                      child: Text(
                                        passwordVerify ? 'Verified' : 'Verify',
                                        style: TextStyle(
                                            color: passwordVerify
                                                ? Colors.green
                                                : Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      )),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Irctc Password';
                              } else if (!passwordVerify) {
                                return 'Verify Your Password First';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Note- Before booking, you must verify your IRCTC password to proceed with the reservation.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[300],
                                fontSize: 11),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'नोट- बुकिंग से पहले, आपको आरआईआरसीटीसी पासवर्ड सत्यापित करना आवश्यक है ताकि आरक्षण की प्रक्रिया पूरी की जा सके।',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[300],
                                fontSize: 11),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pickup Locaion',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: roomController,
                            decoration: InputDecoration(
                              labelText: 'Room No. / Plot No.',
                              hintText: 'Room No. / Plot No.',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Room or Plot Number';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: villageController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: 'Village',
                              hintText: "Village",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Village Name';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: landmarkController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: 'Nearest Landmark',
                              hintText: "Landmark (Optional)",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: pincodeController,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Pincode',
                              hintText: "Pincode",
                              counterText: '',
                              suffixIcon: isLoading
                                  ? Padding(
                                      padding: EdgeInsets.all(10),
                                      child: SizedBox(
                                        height: 3,
                                        width: 3,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ) :
                                    pincodeVerified ? Icon(Icons.verified, color: Colors.green,)
                                  : TextButton(
                                      onPressed: () =>
                                          fetchPincode(pincodeController.text),
                                      child: Text(
                                        'Verify',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      )),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Pincode';
                              } else if (pincodeController.text.length < 6) {
                                return 'Enter Valid Pincode';
                              } else if (!RegExp(r'^[1-9][0-9]{5}$')
                                  .hasMatch(value)) {
                                return 'Enter Valid Pincode';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            value: selectedPostoffice,
                            onChanged: (value) {
                              setState(() {
                                selectedPostoffice = value!;
                              });
                            },
                            items: postofficeList.map((post) {
                              return DropdownMenuItem(
                                  value: post, child: Text(post));
                            }).toList(),
                            decoration: InputDecoration(
                              hintText: "Post Office",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Select Your PostOffice';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: districtController,
                            decoration: InputDecoration(
                              labelText: 'District',
                              hintText: "District",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'District can not be empty';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: stateController,
                            decoration: InputDecoration(
                              labelText: 'State ',
                              hintText: "State",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'State can not be empty';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Note- If the pickup point of any product is more than 50 kilometers, the user will have to pay extra charges.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[300],
                                fontSize: 11),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'नोट- यदि किसी उत्पाद का पिकअप पॉइंट 50 किलोमीटर से अधिक है, तो उपयोगकर्ता को अतिरिक्त शुल्क देना होगा।',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[300],
                                fontSize: 11),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Drop Locaion',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: droproomController,
                            decoration: InputDecoration(
                              labelText: 'Room No. / Plot No.',
                              hintText: 'Room No. / Plot No.',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Room or Plot Number';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: dropVillageController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: 'Village',
                              hintText: "Village",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Village Name';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: dropLandmarkController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: 'Nearest Landmark',
                              hintText: "Landmark (Optional)",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: dropPincodeController,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Pincode',
                              hintText: "Pincode",
                              counterText: '',
                              suffixIcon: isNewLoading
                                  ? Padding(
                                      padding: EdgeInsets.all(10),
                                      child: SizedBox(
                                        height: 3,
                                        width: 3,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ) :
                                    dropPincodeVerified ? Icon(Icons.verified, color: Colors.green,)
                                  : TextButton(
                                      onPressed: () => fetchDropPincode(
                                          dropPincodeController.text),
                                      child: Text(
                                        'Verify',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      )),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Pincode';
                              } else if (pincodeController.text.length < 6) {
                                return 'Enter Valid Pincode';
                              } else if (!RegExp(r'^[1-9][0-9]{5}$')
                                  .hasMatch(value)) {
                                return 'Enter Valid Pincode';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            value: selectedDropPostOffice,
                            onChanged: (value) {
                              setState(() {
                                selectedDropPostOffice = value!;
                              });
                            },
                            items: dropPoList.map((post) {
                              return DropdownMenuItem(
                                  value: post, child: Text(post));
                            }).toList(),
                            decoration: InputDecoration(
                              hintText: "Post Office",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Select Your PostOffice';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: dropDistrictController,
                            decoration: InputDecoration(
                              labelText: 'District',
                              hintText: "District",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'District can not be empty';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: dropStateController,
                            decoration: InputDecoration(
                              labelText: 'State ',
                              hintText: "State",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'State can not be empty';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Note- If the drop point of any product is more than 50 kilometers, the user will have to pay extra charges.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[300],
                                fontSize: 11),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'नोट- यदि किसी उत्पाद का ड्रॉप पॉइंट 50 किलोमीटर से अधिक है, तो उपयोगकर्ता को अतिरिक्त शुल्क देना होगा।',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[300],
                                fontSize: 11),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                saveBookingData(updatedDate);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GenTicket(
                        trainName: widget.trainName,
                        trainNo: widget.trainNo,
                        fromStation: widget.fromStation,
                        destination: widget.destination,
                        boardingStation: widget.boardingStation,
                        boardingDate: widget.journeyDate,
                        irctcUsername: widget.irctcUname,
                        deliveryDate: updatedDate,
                        email: widget.email,
                        phone: widget.phone,
                        roomNo: roomController.text.trim(),
                        village: villageController.text.trim(),
                        landMark: landmarkController.text.trim(),
                        pincode: pincodeController.text.trim(),
                        postoffice: selectedPostoffice.toString(),
                        district: districtController.text.trim(),
                        state: stateController.text.trim(),
                        pickupDate: widget.boardingTime,
                        delRoom: droproomController.text.trim(),
                        delVillage: dropVillageController.text.trim(),
                        dropLandMark: dropLandmarkController.text.trim(),
                        delPincode: dropPincodeController.text.trim(),
                        delPostoffice: selectedDropPostOffice.toString(),
                        delDistrict: dropDistrictController.text.trim(),
                        delState: dropStateController.text.trim(),
                        upiId: widget.upiId,
                        transactionId: widget.transactionId,
                        fare: widget.fare,
                        productDetails: widget.productList)));
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
