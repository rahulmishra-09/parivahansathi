import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/extra%20pages/last_cnf_page.dart';

class TransactionPage extends StatefulWidget {
  final String trainNo,
      trainName,
      fromStation,
      destination,
      boardingStation,
      boardingTime,
      journeyDate,
      irctcUname,
      email,
      phone;

  final int fare;

  final List<Map<String, dynamic>> productList;
  const TransactionPage({
    super.key,
    required this.trainNo,
    required this.trainName,
    required this.fromStation,
    required this.destination,
    required this.boardingStation,
    required this.boardingTime,
    required this.journeyDate,
    required this.irctcUname,
    required this.email,
    required this.phone,
    required this.fare,
    required this.productList,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Select Payment Mode'),
        backgroundColor: Colors.grey[100],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, right: 16.0, left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Due Now',
                          style: textStyle,
                        ),
                        Text(
                          '₹ ${widget.fare.toString()}',
                          style: textStyle,
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.train,
                      color: Colors.orange,
                      size: 36,
                    ),
                    title: Text(
                      widget.trainName,
                      style: textStyle,
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Boarding Station: ${widget.boardingStation}'),
                        Text('Booking Date: ${widget.journeyDate}'),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, right: 16.0, left: 16.0, bottom: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email: ${widget.email}',
                          style: textStyle,
                        ),
                        Text(
                          'Phone: ${widget.phone}',
                          style: textStyle,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Pay Option',
              style: GoogleFonts.merienda(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UPIPayment(
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
                      productList: widget.productList))),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            height: 50,
                            width: 50,
                            child: Image(image: AssetImage('assets/upi.png'))),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'UPI Payment',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UPIPayment extends StatefulWidget {
  final String trainNo,
      trainName,
      fromStation,
      destination,
      boardingStation,
      boardingTime,
      journeyDate,
      irctcUname,
      email,
      phone;

  final int fare;

  final List<Map<String, dynamic>> productList;
  const UPIPayment({
    super.key,
    required this.trainNo,
    required this.trainName,
    required this.fromStation,
    required this.destination,
    required this.boardingStation,
    required this.boardingTime,
    required this.journeyDate,
    required this.irctcUname,
    required this.email,
    required this.phone,
    required this.fare,
    required this.productList,
  });

  @override
  State<UPIPayment> createState() => _UPIPaymentState();
}

class _UPIPaymentState extends State<UPIPayment> {
  final upiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isfocused = false;
  final focusNode = FocusNode();
  bool isError = false;
  String? errorMsg;
  bool isLoading = false;
  bool? isValid;

  Future<void> verifyUpi() async {
    String upiId = upiController.text.trim();

    if (upiId.isEmpty) return;

    setState(() {
      isLoading = true;
      isError = false;
      isValid = null;
    });
    await Future.delayed(Duration(seconds: 2));

    bool isValidUpi = upiId.contains('@') && upiId.length > 5;

    setState(() {
      isValid = isValidUpi;
      isLoading = false;
      if (!isValidUpi) {
        isError = true;
        errorMsg = "Invalid UPI ID";
      }
    });
  }

  String generateTransactionId() {
    math.Random random = math.Random();

    String transactionId = (random.nextInt(9) + 1).toString();

    for (int i = 0; i < 13; i++) {
      transactionId += random.nextInt(10).toString();
    }

    return transactionId;
  }

  void processingPayment() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(Duration(seconds: 15), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LastCnfPage(
                        trainNo: widget.trainNo,
                        trainName: widget.trainName,
                        fromStation: widget.fromStation,
                        destination: widget.destination,
                        boardingStation: widget.boardingStation,
                        boardingTime: widget.boardingTime,
                        journeyDate: widget.journeyDate,
                        transactionId: generateTransactionId(),
                        upiId: upiController.text.trim(),
                        irctcUname: widget.irctcUname,
                        email: widget.email,
                        phone: widget.phone,
                        fare: widget.fare,
                        productList: widget.productList)));
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Processing Your Payment...',
                    style: GoogleFonts.merienda(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      setState(() {
        isfocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void validation() {
    if (upiController.text.isEmpty) {
      setState(() {
        isError = true;
        errorMsg = "UPI ID is required";
      });
    } else {
      setState(() {
        isError = false;
        errorMsg = null;
      });
      processingPayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'Pay via UPI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Due Now',
                        style: GoogleFonts.merienda(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        '${widget.trainName}- #${widget.trainNo}',
                        style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      '₹ ${widget.fare.toString()}',
                      style: GoogleFonts.aBeeZee(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Expanded(
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: isError
                                  ? Colors.red
                                  : (isfocused
                                      ? Colors.blue
                                      : Colors.grey.shade600),
                            )),
                        child: TextFormField(
                          controller: upiController,
                          focusNode: focusNode,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixIcon: isLoading
                                ? Padding(
                                    padding: EdgeInsets.all(10),
                                    child: SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4.0,
                                      ),
                                    ),
                                  )
                                : isValid == null
                                    ? null
                                    : Icon(
                                        isValid!
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: isValid!
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                            labelText: 'ENTER UPI ID',
                            labelStyle: TextStyle(
                                color: isError
                                    ? Colors.red
                                    : (isfocused
                                        ? Colors.blue
                                        : Colors.grey.shade600)),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              isValid = null;
                              isError = false;
                              isLoading = true;
                            });
                            Future.delayed(Duration(seconds: 1), () {
                              verifyUpi();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  if (isError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Text(
                        errorMsg!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  GestureDetector(
                    onTap: validation,
                    child: Container(
                      width: 200,
                      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: isError
                            ? Colors.red
                            : (isfocused ? Colors.blue : Colors.grey.shade600),
                      ),
                      child: Center(
                        child: Text(
                          'PAY',
                          style: GoogleFonts.merienda(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
    );
  }
}
