import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/booking%20ticket/confirmation_page.dart';
import 'package:railway/booking%20ticket/product_details.dart';
import 'package:railway/toast%20message/toast_message.dart';

class UserDetails extends StatefulWidget {
  final String trainName;
  final String trainNumber;
  final String fromStation;
  final String bookingDate;
  final String destination;
  final int amount;
  final String fromStnTime;
  final String destTime;
  const UserDetails(
      {super.key,
      required this.trainName,
      required this.trainNumber,
      required this.fromStation,
      required this.bookingDate,
      required this.destination,
      required this.amount,
      required this.fromStnTime,
      required this.destTime});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final irctcUname = TextEditingController();
  final sheetController = TextEditingController();
  final couponController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  List<Map<String, dynamic>> productList = [];
  int totalAmt = 0;

  void calAmt() {
    int basePrice = widget.amount;
    int newAmt = basePrice;

    for (var product in productList) {
      if (product['isChecked'] == true) {
        int productQty = int.tryParse(product['number'] ?? '1') ?? 1;
        int produceAmt = setAmt(product['weight']) * productQty;
        newAmt += produceAmt;
      }
    }
    setState(() {
      totalAmt = newAmt;
    });
  }

  Future changeIrctc() {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical()),
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 300,
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        'IRCTC Username',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 215, 163),
                        ),
                        child: Text(
                          'Please enter the correct IRCTC username. You will required to enter the password for this IRCTC username before payment.',
                          style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 199, 119, 0)),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: textField(
                          'USERNAME', sheetController, true, 'USERNAME', false),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: submitUsername,
                        child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.lightBlueAccent,
                                    Colors.blueAccent
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14.0)),
                            child: Center(
                              child: Text(
                                'SUBMIT',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void submitUsername() {
    setState(() {
      irctcUname.text = sheetController.text.trim();
    });
    Navigator.pop(context);
  }

  void checkBox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  void validateData() {
    if (irctcUname.text.isEmpty) {
      SnackBarMsg.showSnack(context, 'Enter Irctc Username');
    } else if (productList.isEmpty) {
      SnackBarMsg.showSnack(context, 'Enter Product with proper details.');
    } else if (_isChecked != true) {
      SnackBarMsg.showSnack(context, 'Check you are agree with our agreement!');
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConfirmationPage(
              trainNo: widget.trainNumber,
              trainName: widget.trainName,
              fromStation: widget.fromStation,
              destination: widget.destination,
              boardingStation: widget.fromStation,
              journeyDate: widget.bookingDate,
              irctcUname: irctcUname.text.trim(),
              productList: productList,
              fare: totalAmt,
              email: emailController.text.trim(),
              phone: phoneController.text.trim())));
    }
  }

  @override
  void initState() {
    super.initState();
    totalAmt = widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    var headingTxt = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text(
            'D E T A I L S',
            style: GoogleFonts.dmSans(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.black87,
          elevation: 0,
          notchMargin: 0,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹ $totalAmt/-',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        validateData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
        ),
        body: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.trainName,
                              style: GoogleFonts.merienda(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17),
                            ),
                            Text(
                              '#${widget.trainNumber}',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Source Station:\n ${widget.fromStation}\n\t\t${widget.fromStnTime}',
                                style: GoogleFonts.merienda(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Destination:\n ${widget.destination}\n\t\t${widget.destTime}',
                                style: GoogleFonts.merienda(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Boarding\nStation',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700]),
                          textAlign: TextAlign.start,
                        ),
                        Text(widget.fromStation),
                        Column(
                          children: [
                            Text('Booking Date'),
                            Text(widget.bookingDate)
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IRCTC Username',
                              style: headingTxt,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            GestureDetector(
                              onTap: changeIrctc,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: irctcUname,
                                    style: TextStyle(color: Colors.black),
                                    cursorColor: Colors.black,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        labelText: 'USERNAME',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        suffixIcon: Padding(
                                          padding: EdgeInsets.only(
                                              top: 13, right: 8),
                                          child: Text(
                                            'Change',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                'Product Details',
                                style: headingTxt,
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: productList.length,
                                itemBuilder: (context, index) {
                                  final product = productList[index];
                                  return ListTile(
                                    leading: Checkbox(
                                      value: product['isChecked'] as bool? ??
                                          false,
                                      onChanged: (value) {
                                        setState(() {
                                          productList[index]['isChecked'] =
                                              value ?? false;
                                          calAmt();
                                        });
                                      },
                                      activeColor: Colors.blue,
                                    ),
                                    title: Text(product['name']),
                                    subtitle: Text(
                                        'Weight: ${product['weight']}, Qty: ${product['number']}'),
                                    trailing: TextButton(
                                        onPressed: () async {
                                          final updateProduct =
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetails(
                                                              existingData:
                                                                  product)));
                                          if (updateProduct != null) {
                                            setState(() {
                                              productList[index] =
                                                  updateProduct;
                                            });
                                          } else {
                                            print('Not update');
                                          }
                                        },
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue),
                                        )),
                                  );
                                }),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, bottom: 15.0),
                              child: GestureDetector(
                                onTap: () async {
                                  if (productList.length >= 3) {
                                    ToastMessage.showToast(context,
                                        'Only 3 products can be added..');

                                    return;
                                  }
                                  final result = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetails()));

                                  if (result != null) {
                                    setState(() {
                                      productList.add(result);
                                      calAmt();
                                    });
                                  }
                                },
                                child: Text(
                                  '+\t\t PRODUCT DETAILS',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Offers & Discount',
                            style: headingTxt,
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, bottom: 15.0, right: 15.0),
                            child: textField('Coupon code', couponController,
                                false, 'Enter a coupon code', true)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Contact Details',
                            style: headingTxt,
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, bottom: 15.0, right: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email ID',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                TextFormField(
                                  controller: emailController,
                                  style: TextStyle(color: Colors.black),
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    hintText: 'Eg. xxx@gmail.com',
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  validator: (value) {
                                    String email = emailController.text.trim();
                                    final emailValid = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                    if (value!.isEmpty) {
                                      return 'Enter email address';
                                    } else if (!emailValid.hasMatch(email)) {
                                      return 'Enter valid email address';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Phone Number',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                    controller: phoneController,
                                    maxLength: 10,
                                    style: TextStyle(color: Colors.black),
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      hintText: 'Eg. 9000000000',
                                      hintStyle: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                    validator: (value) {
                                      String phone =
                                          phoneController.text.trim();
                                          final phoneValid = RegExp(r'^[6789]\d{9}$');

                                      if (value!.isEmpty) {
                                        return 'Enter phone number';
                                      } else if (!phoneValid.hasMatch(phone)) {
                                        return 'Enter valid phone number';
                                      } else {
                                        return null;
                                      }
                                    }),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 4),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: checkBox,
                            activeColor: Colors.teal,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0, bottom: 10.0),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text:
                                              'I confirm that I agree to the'),
                                      TextSpan(
                                        text:
                                            ' Cancellation Policy, Booking Policy, Privacy Policy, User Agreement',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text: ' and,',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      TextSpan(
                                          text: ' Terms of Service',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold))
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            )
          ],
        ));
  }

  Widget textField(String? label, TextEditingController controller,
      bool autoFocus, String? hint, bool hintText) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      autofocus: autoFocus,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
        labelText: hintText ? null : label,
        labelStyle: TextStyle(color: Colors.black),
        hintText: hintText ? hint : null,
        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  int setAmt(String? weight) {
    switch (weight) {
      case '100 - 140 KG':
        return 1000;

      case '141 - 200 KG':
        return 2000;

      case '201 - 350 KG':
        return 3500;

      case '350 - above':
        return 5000;

      default:
        return 0;
    }
  }
}
