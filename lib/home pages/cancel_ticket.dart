import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/database/firestore_service.dart';
import 'package:railway/toast%20message/toast_message.dart';

class CancelTicket extends StatefulWidget {
  CancelTicket({super.key});

  @override
  State<CancelTicket> createState() => _CancelTicketState();
}

class _CancelTicketState extends State<CancelTicket> {
  FirestoreService firestoreService = FirestoreService();
  final captchaController = TextEditingController();

  int captchaNum = 1000;

  void generateCaptcha(Function updateState) {
    updateState(() {
      captchaNum = Random().nextInt(9000) + 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text(
            'Cancellation Page',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
          ),
        ),
        body: StreamBuilder(
            stream: firestoreService.fetchTicketData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error To Fetch Data..',
                    style: GoogleFonts.merienda(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Empty..',
                    style: GoogleFonts.merienda(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                );
              } else {
                List<Map<String, dynamic>> tickets = snapshot.data!;

                return ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      var ticket = tickets[index];

                      return Container(
                        decoration: BoxDecoration(color: Colors.grey[100]),
                        margin: EdgeInsets.symmetric(vertical: 3),
                        child: ListTile(
                          leading: Icon(
                            Icons.train,
                            color: Colors.red,
                            size: 40,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ticket['trainName'],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '# ${ticket['trainNo']}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text('Boarding Station'),
                                      Text(ticket['boardingStation'])
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Operation'),
                                      InkWell(
                                          onTap: ticket['bookingStatus'] ==
                                                  'cancelled'
                                              ? () => SnackBarMsg.showSnack(
                                                  context,
                                                  'You Already Cancelled This Ticket!!') :
                                                  ticket['orderStatus'] == 'Delivered' ?
                                                  () => SnackBarMsg.showSnack(
                                                  context,
                                                  'Your order is already delivered!!')
                                              : () => cancelAlert(
                                                  context, ticket['id']),
                                          child: Text( ticket['bookingStatus'] == 'cancelled' ?
                                            'Cancelled' : 'Cancel Ticket',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text('Booking Date'),
                                      Text(ticket['bookingDate'])
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Pickup Date'),
                                      Text(ticket['boardingTime'])
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }));
  }

  void cancelAlert(BuildContext context, String ticketId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateDialog) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: 45,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Cancel Booking?',
                    style: GoogleFonts.merienda(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to cancel this ticket? This action cannot be undone, and cancellation charges may apply.",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Enter Captcha',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7.0),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          captchaNum.toString().split('').join(' '),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 68, 44, 7),
                              fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: () {
                            generateCaptcha(setStateDialog);
                          },
                          icon: Icon(Icons.refresh)),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: captchaController,
                          maxLength: 4,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintText: '',
                              counterText: '',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                              border: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder()),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      captchaController.clear();
                    },
                    child: Text(
                      'Exit',
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton(
                    onPressed: () async {
                      if(captchaNum.toString() == captchaController.text.trim()) {
                        await firestoreService.cancelTickt(ticketId);
                      Navigator.pop(context);
                      captchaController.clear();
                      
                      } else {
                        SnackBarMsg.showSnack(context, 'Fill Captcha Field Properly!!');
                      }
                    },
                    child: Text(
                      'Proceed',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            );
          });
        });
  }
}
