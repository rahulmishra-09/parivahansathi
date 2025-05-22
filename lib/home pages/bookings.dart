import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/database/firestore_service.dart';
import 'package:railway/extra%20pages/gen_ticket.dart';

class Bookings extends StatelessWidget {
  Bookings({super.key});
  FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          'Booking Page',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.fetchTicketData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error to Find Data!!',
              style: GoogleFonts.merienda(
                  fontWeight: FontWeight.bold, fontSize: 24),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Bookings Yet...',
                style: GoogleFonts.merienda(
                    fontWeight: FontWeight.bold, fontSize: 24),
              ),
            );
          } else {
            List<Map<String, dynamic>> bookings = snapshot.data!;

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                var booking = bookings[index];
                return GestureDetector(
                  onTap: booking['bookingStatus'] == 'cancelled'
                      ? null
                      : () {
                          try {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GenTicket(
                                  trainName: booking['trainName'],
                                  trainNo: booking['trainNo'],
                                  fromStation: booking['fromStation'],
                                  destination: booking['destination'],
                                  boardingStation: booking['boardingStation'],
                                  boardingDate: booking['boardingTime'],
                                  irctcUsername: booking['irctcUname'],
                                  email: booking['email'],
                                  phone: booking['phone'],
                                  roomNo: booking['pickupAddress']['room'],
                                  village: booking['pickupAddress']['village'],
                                  landMark: booking['pickupAddress']
                                      ['landmark'],
                                  pincode: booking['pickupAddress']['pincode'],
                                  postoffice: booking['pickupAddress']
                                      ['postoffice'],
                                  district: booking['pickupAddress']
                                      ['district'],
                                  state: booking['pickupAddress']['state'],
                                  pickupDate: booking['journeyDate'],
                                  delRoom: booking['dropAddress']['room'],
                                  delVillage: booking['dropAddress']['village'],
                                  dropLandMark: booking['dropAddress']
                                      ['landmark'],
                                  delPincode: booking['dropAddress']['pincode'],
                                  delPostoffice: booking['dropAddress']
                                      ['postoffice'],
                                  delDistrict: booking['dropAddress']
                                      ['district'],
                                  delState: booking['dropAddress']['state'],
                                  deliveryDate: booking['deliveryDate'],
                                  upiId: booking['upiId'],
                                  transactionId: booking['transactionId'],
                                  fare: booking['fare'],
                                  productDetails:
                                      (booking['productList'] as List?)
                                              ?.map((list) =>
                                                  list as Map<String, dynamic>)
                                              .toList() ??
                                          [],
                                ),
                                fullscreenDialog: true,
                              ),
                            );
                            print("Drop Address: ${booking['dropAddress']}");
                          } catch (e) {
                            print("Error navigating to GenTicket: $e");
                          }
                        },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    margin: EdgeInsets.symmetric(vertical: 3),
                    child: ListTile(
                      leading: Icon(
                        Icons.train,
                        color: Colors.orange,
                        size: 40,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            booking['trainName'],
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '# ${booking['trainNo']}',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text('Boarding Station'),
                                  Text(booking['boardingStation'])
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Booking Status'),
                                  Text(
                                    booking['bookingStatus'] == 'cancelled'
                                        ? 'Cancelled'
                                        : booking['orderStatus'] == 'Delivered'
                                            ? 'Delivered'
                                            : booking['orderStatus'] ==
                                                    'Order Invalid'
                                                ? 'Invalid'
                                                : 'Booked',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          booking['orderStatus'] == 'Delivered'
                                              ? Colors.orange
                                              : booking['orderStatus'] ==
                                                      'Order Invalid'
                                                  ? Colors.redAccent[200]
                                                  : booking['bookingStatus'] ==
                                                          'cancelled'
                                                      ? Colors.red
                                                      : Colors.green,
                                    ),
                                  )
                                ],
                              )
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
                                  Text('Booking Date'),
                                  Text(booking['bookingDate'])
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Pickup Date'),
                                  Text(booking['boardingTime'])
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
