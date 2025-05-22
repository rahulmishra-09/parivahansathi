import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/extra%20pages/contactus.dart';
import 'package:railway/extra%20pages/emergency.dart';
import 'package:railway/home%20pages/alert_notification.dart';
import 'package:railway/booking%20ticket/book_ticket.dart';
import 'package:railway/home%20pages/bookings.dart';
import 'package:railway/home%20pages/cancel_ticket.dart';
import 'package:railway/home%20pages/order_details.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void backButtonPress() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              title: Text(
                'Exit Alert',
                style: GoogleFonts.merienda(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Are you sure you want to exit?',
                style: GoogleFonts.merienda(),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Text(
                        'No',
                        style: GoogleFonts.merienda(),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Text(
                        'Yes',
                        style: GoogleFonts.merienda(),
                      ),
                      onTap: () {
                        exit(0);
                      },
                    )
                  ],
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Hero(
          tag: "Rail connected",
          child: Text('ParivahanSathi',
              style: GoogleFonts.merienda(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: backButtonPress,
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AlertNotification(),
                  fullscreenDialog: true,
                ));
              },
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5, left: 5, top: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => BookTicket(),
                                      fullscreenDialog: true)),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: Colors.grey[100],
                                elevation: 4,
                              ),
                              child: Icon(
                                Icons.train,
                                color: Colors.teal,
                                size: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Book Ticket',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Bookings(),
                                    fullscreenDialog: true,
                                  )),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: Colors.grey[100],
                                elevation: 4,
                              ),
                              child: Icon(
                                CupertinoIcons.ticket,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Bookings',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderDetails(),
                                      fullscreenDialog: true)),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: Colors.grey[100],
                                elevation: 4,
                              ),
                              child: Icon(
                                Icons.track_changes,
                                color: const Color.fromARGB(255, 0, 54, 95),
                                size: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Order Details',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Emergency()));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: Colors.grey[100],
                                elevation: 4,
                              ),
                              child: Icon(
                                Icons.emergency,
                                color: Colors.redAccent,
                                size: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Emergency',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CancelTicket(),
                                    fullscreenDialog: true,
                                  )),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: Colors.grey[100],
                                elevation: 4,
                              ),
                              child: Icon(
                                Icons.cancel,
                                color: const Color.fromARGB(255, 97, 1, 1),
                                size: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Cancel\nTicket',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _launchOnBrowser(
                                  'https://enquiry.indianrail.gov.in/mntes/'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: Colors.grey[100],
                                elevation: 4,
                              ),
                              child: Icon(
                                CupertinoIcons.location,
                                color: const Color.fromARGB(255, 249, 61, 255),
                                size: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Track Your\nBooking',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _launchOnBrowser(
                                  'https://equery.irctc.co.in/irctc_equery/'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: Colors.grey[100],
                                elevation: 4,
                              ),
                              child: Icon(
                                Icons.help,
                                color: Colors.amber,
                                size: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Help &\nSupport',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => Contactus())),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: Colors.grey[100],
                                elevation: 4,
                              ),
                              child: Icon(
                                Icons.contact_page,
                                color: Colors.blueGrey,
                                size: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Contact Us\n',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              height: 10,
              width: double.maxFinite,
              color: Colors.grey[400],
            ),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text(
                    'BIG OR SMALL, WE DELIVER IT ALL!!',
                    style: GoogleFonts.merienda(
                        fontSize: 17,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '...PARIVAHANSATHI...',
                    style: GoogleFonts.merienda(
                        fontSize: 20,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              height: 10,
              width: double.maxFinite,
              color: Colors.grey[400],
            ),
            Center(
              child: Container(
                height: 400,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/home_image.jpg'),
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

  Future<void> _launchOnBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch this url';
    }
  }
}
