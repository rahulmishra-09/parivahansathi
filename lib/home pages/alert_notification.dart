import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:railway/database/firestore_service.dart';

class AlertNotification extends StatelessWidget {
  AlertNotification({super.key});

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: Text(
            'N O T I F I C A T I O N S',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: StreamBuilder(
                stream: firestoreService.getMessage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text(
                      'No notifications yet 😢',
                      style: GoogleFonts.merienda(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ));
                  }
                  List<Map<String, dynamic>> messageList =
                      snapshot.data!.docs.map((doc) {
                    return doc.data() as Map<String, dynamic>;
                  }).toList();

                  return ListView.builder(
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        final message = messageList[index];

                        return Card(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: Colors.grey[200],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        message['title'],
                                        style: GoogleFonts.aBeeZee(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.red),
                                      ),
                                    )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(message['content'],
                                      style: GoogleFonts.merienda(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    )),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                        child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        DateFormat('dd-MM-yyyy HH:mm').format(
                                            message['timestamp'].toDate()),
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                })));
  }
}
