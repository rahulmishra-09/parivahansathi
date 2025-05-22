import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:railway/booking%20ticket/transaction_page.dart';

class ConfirmationPage extends StatefulWidget {
  final String trainNo,
      trainName,
      fromStation,
      destination,
      boardingStation,
      journeyDate,
      irctcUname,
      email,
      phone;

  final int fare;


  final List<Map<String, dynamic>> productList;

  const ConfirmationPage({
    super.key,
    required this.trainNo,
    required this.trainName,
    required this.fromStation,
    required this.destination,
    required this.boardingStation,
    required this.journeyDate,
    required this.irctcUname,
    required this.productList,
    required this.email,
    required this.phone,
    required this.fare,
  });

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    DateTime dateParse = DateFormat('dd-MM-yyyy').parse(widget.journeyDate);
    DateTime boardingDate = dateParse.subtract(Duration(days: 2));
    String formatedDate = DateFormat('dd-MM-yyyy').format(boardingDate);

    var textStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
    var dataTxt = TextStyle(
        color: Colors.grey[800], fontWeight: FontWeight.bold, fontSize: 12);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: Text(
            'Booking Review',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w900, color: Colors.white),
          ),
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
                  '₹ ${widget.fare}/-',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TransactionPage(
                              trainNo: widget.trainNo,
                              trainName: widget.trainName,
                              fromStation: widget.fromStation,
                              destination: widget.destination,
                              boardingStation: widget.boardingStation,
                              journeyDate: widget.journeyDate,
                              boardingTime: formatedDate,
                              irctcUname: widget.irctcUname,
                              email: widget.email,
                              phone: widget.phone,
                              fare: widget.fare,
                              productList: widget.productList)));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    child: Text(
                      'Pay and Book',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.trainName,
                        style: textStyle,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'From Station: \n${widget.fromStation}',
                        style: dataTxt,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '# ${widget.trainNo}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Destination Station: \n${widget.destination}',
                        style: dataTxt,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Boarding Station',
                              style: textStyle,
                            ),
                            Text(
                              widget.boardingStation,
                              style: dataTxt,
                            )
                          ],
                        ),
                        Text(
                          'Boarding Date: \n${widget.journeyDate}',
                          style: dataTxt,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.grey[100],
                    elevation: 3,
                    shape: RoundedRectangleBorder(),
                    child: Flexible(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(24),
                        decoration: BoxDecoration(color: Colors.grey[100]),
                        child: Column(
                            children: widget.productList.map((product) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  '${product['name'].toString().toUpperCase()} → [Weight-${product['weight']}], (Qty- ${product['number']})',
                                  style: dataTxt,
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              )
                            ],
                          );
                        }).toList()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'More Details',
                        style: textStyle,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blue,
                            size: 28,
                          ))
                    ],
                  ),
                  if(isExpanded) ...[
                    const Divider(color: Colors.black,),
                    Padding(padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('IRCTC Username: ', style: dataTxt,),
                            Text(widget.irctcUname, style: dataTxt,),
                          ],
                        ),
                         const SizedBox(height: 5,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Email Address: ', style: dataTxt,),
                            Text(widget.email, style: dataTxt,),
                          ],
                        ),
                         const SizedBox(height: 5,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phone Number: ', style: dataTxt,),
                            Text('+91 ${widget.phone}', style: dataTxt,),
                          ],
                        ),
                      ],
                    ),
                    )
                  ]
                ],
              ),
            ),
          ],
        ));
  }
}
