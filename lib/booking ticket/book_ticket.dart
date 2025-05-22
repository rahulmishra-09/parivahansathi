import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:railway/booking%20ticket/city_page.dart';
import 'package:railway/booking%20ticket/train_page.dart';
import 'package:railway/toast%20message/toast_message.dart';

class BookTicket extends StatefulWidget {
  const BookTicket({super.key});

  @override
  State<BookTicket> createState() => _BookTicketState();
}

class _BookTicketState extends State<BookTicket> {
  final _dateController = TextEditingController();
  String fromStnCode = "STN";
  String fromStnName = "Station Name";
  String toStnCode = "STN";
  String toStnName = "Station Name";

  String? products;
  String? selectedDay;

  void _swapStation() {
    setState(() {
      String tempCode = fromStnCode;
      fromStnCode = toStnCode;
      toStnCode = tempCode;
      String tempName = fromStnName;
      fromStnName = toStnName;
      toStnName = tempName;
    });
  }

  Future<void> _selectStation(bool isFromStation) async {
    final selectedStation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CityPage()),
    );

    if (selectedStation != null && selectedStation is String) {
      List<String> stationDetails = selectedStation.split("-");
      if (stationDetails.length == 2) {
        setState(() {
          if (isFromStation) {
            fromStnCode = stationDetails[0];
            fromStnName = stationDetails[1];
          } else {
            toStnCode = stationDetails[0];
            toStnName = stationDetails[1];
          }
        });
      }
    }
  }

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
          'Book Ticket',
          style: GoogleFonts.merienda(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: _stationColumn("From", fromStnCode, fromStnName, true)),
                  IconButton(
                      onPressed: _swapStation,
                      icon: Icon(
                        Icons.swap_horiz,
                        color: Colors.black,
                        size: 40,
                      )),
                  Expanded(child: _stationColumn("To", toStnCode, toStnName, false)),
                ],
              ),
            ),
          ),
          Divider(),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: Colors.deepOrange)),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                    hintText: 'Select Date',
                    labelText: 'Select Date',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
                readOnly: true,
                onTap: _selectDate,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async{
                if (fromStnCode == toStnCode) {
                  ToastMessage.showToast(context,
                      'Source and detination station should different!');
                } else {
                  await showTrains();
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              child: Text(
                'Search Train',
                style: GoogleFonts.merienda(fontSize: 20, color: Colors.white),
              ))
        ],
      ),
    );
  }

  Future<void> showTrains() async {
  try {
    if(fromStnCode == 'STN') {
      SnackBarMsg.showSnack(context, 'Enter Source Station');
      return;
    } else if(toStnCode == 'STN'){
      SnackBarMsg.showSnack(context, 'Enter Destination Station');
      return;
    }else if(_dateController.text.isEmpty) {
      SnackBarMsg.showSnack(context, 'Select Date!');
      return;
    }

    if(fromStnCode == toStnCode) {
      ToastMessage.showToast(context, "Source and destination cannot be the same!");
      return;
    }
    String formattedSource = "$fromStnCode- $fromStnName".toUpperCase();
    String formattedDest = "$toStnCode- $toStnName".toUpperCase();
    String selectWeek = selectedDay ?? "";

    final trnSnapshot = await FirebaseFirestore.instance
        .collection('trains')
        .where('sourcestation', isEqualTo: formattedSource)
        .where('deststation', isEqualTo: formattedDest)
        .get();

        if (trnSnapshot.docs.isEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TrainPage(trains: [], selectedDay: _dateController.text.trim()),
        fullscreenDialog: true,
      ));
      return;
    }

    final trainDoc = trnSnapshot.docs.where((train) {
      var trainData = train.data();
      List<dynamic>? runningDays = trainData['runningdays'];
      return runningDays != null && runningDays.contains(selectWeek);
    }).toList();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TrainPage(trains: trainDoc, selectedDay: _dateController.text.trim()),
    ));

  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Center(child: Text("An error occurred. Please try again.")),
      ),
    );
  }
}
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().add(Duration(days: 7)),
        initialDate: DateTime.now().add(Duration(days: 7)),
        lastDate: DateTime.now().add(Duration(days: 40)));

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy (EEEE)').format(picked);
        selectedDay = DateFormat('EEEE').format(picked);
      });
    }
  }

  Widget stnTextField(String? hint, String label,
      TextEditingController controller, VoidCallback onTap) {
    return SizedBox(
      width: 80,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hint,
            labelText: label,
            hintStyle: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.w300, fontSize: 24, color: Colors.black),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none),
        readOnly: true,
        keyboardType: TextInputType.none,
        onTap: onTap,
      ),
    );
  }

  Widget _stationColumn(
      String title, String code, String name, bool isFromStation) {
    return GestureDetector(
      onTap: () => _selectStation(isFromStation),
      child: SizedBox(
        width: 150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(code,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
            SizedBox(height: 5),
            Flexible(
                child: Text(name,
                    style: TextStyle(fontSize: 12, color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}


/*
/*Future<void> showTrains() async {
    try {
      String formattedSource = "$fromStnCode- $fromStnName".toUpperCase();
      String fromattedDest = "$toStnCode- $toStnName".toUpperCase();

      String selectWeek = selectedDay ?? "";

      final trnSnapshot = await FirebaseFirestore.instance
          .collection('trains')
          .where('sourcestation', isEqualTo: formattedSource)
          .where('deststation', isEqualTo: fromattedDest)
          .get();

      final trainDoc = trnSnapshot.docs.where((train) {
        var trainData = train.data();

        List<dynamic>? runningDays = trainData['runningdays'];
        if (runningDays == null || runningDays.isEmpty) {
          return false;
        }
        if (runningDays.contains(selectWeek)) {
          return true;
        } else {
          return false;
        }
      }).toList();

      if (trainDoc.isNotEmpty) {
         Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TrainPage(
              trains: trainDoc,
              selectedDay: _dateController.text.trim(),
              )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Center(child: Text("Please enter proper details first..")),
          ),
        );
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
*/ */