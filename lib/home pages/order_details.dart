import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/database/firestore_service.dart';

class OrderDetails extends StatelessWidget {
  OrderDetails({super.key});
  FirestoreService firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 54, 95),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: Text(
            'Order Details',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: StreamBuilder(
            stream: firestoreService.fetchTicketData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: const Color.fromARGB(255, 0, 54, 95),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error to found order',
                    style: GoogleFonts.merienda(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No Orders Yet...',
                    style: GoogleFonts.merienda(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                );
              } else {
                List<Map<String, dynamic>> orders = snapshot.data!;

                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      var order = orders[index];

                      return Container(
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        margin: EdgeInsets.symmetric(vertical: 3),
                        child: ListTile(
                          leading: Icon(
                            Icons.production_quantity_limits,
                            size: 40,
                            color: Color(0xff00192A),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (order['productList'] as List<dynamic>)
                                .map((product) {
                              return Text(
                                '${product['name'].toString().toUpperCase()} → ${product['weight'].toString()} [Qty- ${product['number']}]',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              );
                            }).toList(),
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
                                      Text(order['boardingStation'])
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Delivery Status'),
                                      Text(
                                        order['bookingStatus'] == 'cancelled'
                                            ? 'Cancelled'
                                            : order['orderStatus'] ==
                                                    'Order Invalid'
                                                ? 'Invalid'
                                                : order['orderStatus'] ==
                                                        'Picked'
                                                    ? 'Not Delivered Yet'
                                                    : order['orderStatus'] ==
                                                            'Delivered'
                                                        ? 'Delivered'
                                                        : 'Not Picked Yet',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: order['bookingStatus'] ==
                                                  'cancelled'
                                              ? Colors.red
                                              : order['orderStatus'] ==
                                                      'Delivered'
                                                  ? Colors.green
                                                  : Colors.orange,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text('Pickup Date'),
                                      Text(order['boardingTime'])
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Delivery Date'),
                                      Text(order['deliveryDate'])
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
}
