import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/booking%20ticket/user_details.dart';
import 'package:railway/toast%20message/toast_message.dart';

class TrainPage extends StatelessWidget {
  final List<QueryDocumentSnapshot> trains;
  final String selectedDay;
  const TrainPage({super.key, required this.trains, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Train Details',
          style: GoogleFonts.merienda(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: trains.isEmpty
          ? Center(
              child: Expanded(
                child: Text(
                  'No trains available on this route for the selected date.😢',
                  style: GoogleFonts.merienda(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              itemCount: trains.length,
              itemBuilder: (context, index) {
                var train = trains[index].data() as Map<String, dynamic>;
                bool isAvailable = train['isAvailable'] ?? false;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  child: GestureDetector(
                    onTap: () {
                      if (isAvailable) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserDetails(
                              trainName: train['trainname'], 
                              trainNumber: train['trainno'], 
                              fromStation: train['sourcestation'],
                              bookingDate: selectedDay,
                              destination: train['deststation'],
                              amount: train['ticketfare'],
                              fromStnTime: train['srcTime'],
                              destTime: train['destTime'],
                              )));
                      } else {
                        ToastMessage.showToast(context, 'Booking not allowed!!');
                      }
                    },
                    child: Card(
                      color: Colors.grey[200],
                      child: ListTile(
                        title: Text(
                          "${train['trainno']}- ${train['trainname']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                        ),
                        subtitle: Text(
                            "${train['sourcestation']} → ${train['deststation']}\n${train['srcTime']} → ${train['destTime']}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Fare: ₹${train['ticketfare']}",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              isAvailable ? "Available" : "NotAvailable",
                              style: TextStyle(
                                  color:
                                      isAvailable ? Colors.green : Colors.red),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
