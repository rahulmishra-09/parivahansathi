import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:railway/dashboard/dashboard.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class GenTicket extends StatefulWidget {
  final String trainName,
      trainNo,
      fromStation,
      destination,
      boardingStation,
      boardingDate,
      irctcUsername,
      email,
      phone,
      roomNo,
      village,
      pincode,
      postoffice,
      district,
      state,
      pickupDate,
      deliveryDate,
      delRoom,
      delVillage,
      delPincode,
      delPostoffice,
      delDistrict,
      delState,
      upiId,
      transactionId;
  int fare;
  final String? landMark, dropLandMark;
  List<Map<String, dynamic>> productDetails;
  GenTicket({
    super.key,
    required this.trainName,
    required this.trainNo,
    required this.fromStation,
    required this.destination,
    required this.boardingStation,
    required this.boardingDate,
    required this.deliveryDate,
    required this.irctcUsername,
    required this.email,
    required this.phone,
    required this.roomNo,
    required this.village,
    required this.pincode,
    required this.postoffice,
    required this.district,
    required this.state,
    required this.pickupDate,
    required this.delRoom,
    required this.delVillage,
    required this.delPincode,
    required this.delPostoffice,
    required this.delDistrict,
    required this.delState,
    required this.upiId,
    required this.transactionId,
    required this.fare,
    required this.productDetails,
    this.landMark,
    this.dropLandMark,
  });

  @override
  State<GenTicket> createState() => _GenTicketState();
}

class _GenTicketState extends State<GenTicket> {
  final formatDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  Future<Uint8List> generateTicket() async {
    final pdf = pw.Document();
    final imageBytes = await rootBundle.load('assets/rail.png');
    final logo = pw.MemoryImage(imageBytes.buffer.asUint8List());
    /*final meriendaFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Merienda-VariableFont_wght.ttf'),
    );*/

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collectionGroup('bookings').get();

    pw.Widget buildSectionTitle(String title) => pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        );

    pw.Widget buildTableRow(String label, String value) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(value),
          ],
        );

    pw.Widget buildTable(List<List<String>> rows) {
      return pw.Table(
        border: pw.TableBorder.all(color: PdfColors.black),
        columnWidths: {0: pw.FixedColumnWidth(130)},
        children: rows.map((row) {
          return pw.TableRow(
              children: row.map((cell) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(cell,
                  style: const pw.TextStyle(
                    fontSize: 10,
                  )),
            );
          }).toList());
        }).toList(),
      );
    }

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String bookingStatus = data['bookingStatus'] == null
          ? 'Booked'
          : (data['bookingStatus'] == 'cancelled' ? 'Cancelled' : 'Booked');

      String orderStatus = data['orderStatus'] == null
          ? 'Valid'
          : (data['orderStatus'] == 'Order Invalid'
              ? 'Invalid Order'
              : 'Valid Order');

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Center(
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                  pw.Row(children: [
                    pw.SizedBox(height: 80, width: 80, child: pw.Image(logo)),
                    pw.Text(
                      'ParivahanSathi',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ]),
                  pw.Text(
                    formatDate,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10),
                  )
                ])),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 2.6),
            pw.Container(
              padding: pw.EdgeInsets.all(10.0),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(widget.trainName,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 16)),
                      pw.Text('# ${widget.trainNo}',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 16)),
                    ]),
                pw.SizedBox(height: 5),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(children: [
                        pw.Text('Journey From',
                            style: pw.TextStyle(fontSize: 13)),
                        pw.Text(widget.boardingStation,
                            style: pw.TextStyle(fontSize: 12)),
                      ]),
                      pw.Column(children: [
                        pw.Text('Journey To',
                            style: pw.TextStyle(fontSize: 13)),
                        pw.Text(widget.destination,
                            style: pw.TextStyle(fontSize: 12)),
                      ]),
                    ]),
                pw.SizedBox(height: 5),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(children: [
                        pw.Text('Boarding Station',
                            style: pw.TextStyle(fontSize: 13)),
                        pw.Text(widget.boardingStation,
                            style: pw.TextStyle(fontSize: 12)),
                      ]),
                      pw.Column(children: [
                        pw.Text('Boarding Date',
                            style: pw.TextStyle(fontSize: 13)),
                        pw.Text(widget.boardingDate,
                            style: pw.TextStyle(fontSize: 12)),
                      ]),
                    ]),
                pw.SizedBox(height: 5),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(children: [
                        pw.Text('Booking Status',
                            style: pw.TextStyle(fontSize: 14)),
                        pw.Text(bookingStatus,
                            style: pw.TextStyle(
                                fontSize: 13,
                                fontWeight:  pw.FontWeight.bold,
                                color: data['bookingStatus'] == 'cancelled'
                                    ? PdfColors.red
                                    : PdfColors.green)),
                      ]),
                      pw.Column(children: [
                        pw.Text('Order Validity',
                            style: pw.TextStyle(
                              fontSize: 14,
                            )),
                        pw.Text(orderStatus,
                            style: pw.TextStyle(
                                fontSize: 13,
                                fontWeight:  pw.FontWeight.bold,
                                color: data['orderStatus'] == 'Order Invalid'
                                    ? PdfColors.red
                                    : PdfColors.green)),
                      ]),
                    ]),
              ]),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 2.6),
            buildTableRow('IRCTC Username:', widget.irctcUsername),
            buildTableRow('Email:', widget.email),
            buildTableRow('Phone:', widget.phone),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 2.6),
            buildSectionTitle('Product Details'),
            pw.SizedBox(height: 5),
            pw.Container(
              color: PdfColors.grey300,
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: widget.productDetails.map((product) {
                  return pw.Text(
                    '${product['name'].toString().toUpperCase()} - [Weight-${product['weight']}], (Qty- ${product['number']})',
                    style: const pw.TextStyle(fontSize: 10),
                  );
                }).toList(),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 2.6),
            buildSectionTitle('Pickup Location'),
            pw.SizedBox(height: 5),
            buildTable([
              ['Room/Plot No:', widget.roomNo],
              ['Village', widget.village.toUpperCase()],
              [
                'LandMark',
                widget.landMark != null && widget.landMark!.isNotEmpty
                    ? widget.landMark!
                    : 'No Data'
              ],
              ['Pin Code', widget.pincode],
              ['Post Office', widget.postoffice],
              ['District', widget.district],
              ['State', widget.state],
              ['Pickup Date', widget.pickupDate],
            ]),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 2.6),
            buildSectionTitle('Drop Location'),
            pw.SizedBox(height: 5),
            buildTable([
              ['Room/Plot No:', widget.delRoom],
              ['Village', widget.delVillage.toUpperCase()],
              [
                'LandMark',
                widget.dropLandMark != null && widget.dropLandMark!.isNotEmpty
                    ? widget.dropLandMark!
                    : 'No Data'
              ],
              ['Pin Code', widget.delPincode],
              ['Post Office', widget.delPostoffice],
              ['District', widget.delDistrict],
              ['State', widget.delState],
              ['Delivery Date', widget.deliveryDate],
            ]),
            pw.SizedBox(height: 5),
            pw.Text(
              'Note- The product may be delivered before the given delivery date.',
              style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
            ),
            /* pw.Text(
            'नोट- उत्पाद दी गई तारीख से पहले डिलीवर किया जा सकता है।',
            style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
          ),*/
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 2.6),
            buildSectionTitle('Transaction Details'),
            pw.SizedBox(height: 5),
            buildTable([
              ['Payment Method:', 'UPI(India)'],
              ['Payment Type:', 'Online'],
              ['UPI ID:', widget.upiId],
              ['Transaction ID:', widget.transactionId],
              ['Total Price:', 'INR. ${widget.fare}'],
              ['Payment Status', 'Success'],
            ]),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 2.6),
            pw.Text(
              'Note- This form field is only for the delivery or receiving agent/person.',
              style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
            ),
            /* pw.Text(
            'नोट- यह फ़ॉर्म फ़ील्ड केवल डिलीवरी या रिसीविंग एजेंट/व्यक्ति के लिए है।',
            style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
          ),*/
            pw.SizedBox(height: 15),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(children: [
                  pw.Text('Parcel Receiver Details'),
                  pw.Text('[Date/Name/Sign]'),
                  pw.SizedBox(height: 20),
                  pw.Container(height: 1, width: 150, color: PdfColors.black),
                  pw.SizedBox(height: 20),
                  pw.Container(height: 1, width: 150, color: PdfColors.black),
                  pw.SizedBox(height: 20),
                  pw.Container(height: 1, width: 150, color: PdfColors.black),
                ]),
                pw.Column(children: [
                  pw.Text('Parcel Delivery Details'),
                  pw.Text('[Date/Name/Sign]'),
                  pw.SizedBox(height: 20),
                  pw.Container(height: 1, width: 150, color: PdfColors.black),
                  pw.SizedBox(height: 20),
                  pw.Container(height: 1, width: 150, color: PdfColors.black),
                  pw.SizedBox(height: 20),
                  pw.Container(height: 1, width: 150, color: PdfColors.black),
                ]),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Note- Before delivery, both the receiver and the delivery person must sign or fill in the required details. If either refuses to sign, please contact 139 and file a complaint.',
              style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
            ),
            /*pw.Text(
            'नोट- डिलीवरी से पहले प्राप्तकर्ता और डिलीवरी कर्मी दोनों को साइन करना या आवश्यक विवरण भरना अनिवार्य है। यदि कोई भी साइन करने से मना करता है, तो कृपया 139 पर संपर्क करें और शिकायत दर्ज करें।',
            style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
          ),*/
            pw.SizedBox(height: 20),
            pw.Divider(thickness: 2.0, color: PdfColors.black),
          ],
        ),
      );
    }

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    var dataStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10);
    var textStyle = TextStyle(
        color: Colors.grey[900], fontWeight: FontWeight.w500, fontSize: 12);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (isPop, result) {
        if (!isPop) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
              (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final pdfBytes = await generateTicket();
              await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
            } catch (e) {
              print('PDF generation failed: $e');
            }
          },
          shape: CircleBorder(),
          backgroundColor: Colors.black,
          elevation: 9,
          child: Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            height: 80,
                            width: 80,
                            child: Image(image: AssetImage('assets/rail.png'))),
                        Text(
                          'ParivahanSathi',
                          style: GoogleFonts.merienda(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    Text(
                      formatDate,
                      style: dataStyle,
                    )
                  ],
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2.6,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.trainName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 14),
                              ),
                              Text(
                                '# ${widget.trainNo}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Journey From',
                                    style: textStyle,
                                  ),
                                  Text(
                                    widget.boardingStation,
                                    style: textStyle,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Journey To',
                                    style: textStyle,
                                  ),
                                  Text(
                                    widget.destination,
                                    style: textStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
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
                                    style: textStyle,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Boarding Date',
                                    style: textStyle,
                                  ),
                                  Text(
                                    widget.boardingDate,
                                    style: textStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2.6,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'IRCTC Username:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 14),
                              ),
                              Text(
                                widget.irctcUsername,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email Address:',
                                style: textStyle,
                              ),
                              Text(
                                widget.email,
                                style: textStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone Number:',
                                style: textStyle,
                              ),
                              Text(
                                widget.phone,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2.6,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Details',
                      style: GoogleFonts.merienda(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Card(
                        elevation: 2,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.grey[300]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.productDetails.map((product) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${product['name'].toString().toUpperCase()} → [Weight-${product['weight']}], (Qty- ${product['number']})',
                                      style: textStyle,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  )
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 2.6,
                    ),
                    Text(
                      'Pickup Location',
                      style: GoogleFonts.merienda(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: {0: FixedColumnWidth(130)},
                      children: [
                        TableRow(children: [
                          tableData(
                            'Room/Plot No:',
                          ),
                          tableContent(widget.roomNo),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Village ',
                          ),
                          tableContent(widget.village.toUpperCase()),
                        ]),
                        TableRow(children: [
                          tableData(
                            'LandMark',
                          ),
                          tableContent(widget.landMark != null &&
                                  widget.landMark!.isNotEmpty
                              ? '${widget.landMark}'
                              : 'No Data'),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Pin Code',
                          ),
                          tableContent(widget.pincode),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Post Office',
                          ),
                          tableContent(widget.postoffice),
                        ]),
                        TableRow(children: [
                          tableData(
                            'District',
                          ),
                          tableContent(widget.district),
                        ]),
                        TableRow(children: [
                          tableData(
                            'State',
                          ),
                          tableContent(widget.state),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Pickup Date',
                          ),
                          tableContent(widget.pickupDate),
                        ]),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 2.6,
                    ),
                    Text(
                      'Drop Location',
                      style: GoogleFonts.merienda(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: {0: FixedColumnWidth(130)},
                      children: [
                        TableRow(children: [
                          tableData(
                            'Room/Plot No:',
                          ),
                          tableContent(widget.delRoom),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Village ',
                          ),
                          tableContent(widget.delVillage.toUpperCase()),
                        ]),
                        TableRow(children: [
                          tableData(
                            'LandMark',
                          ),
                          tableContent(widget.dropLandMark != null &&
                                  widget.dropLandMark!.isNotEmpty
                              ? '${widget.dropLandMark}'
                              : 'No Data'),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Pin Code',
                          ),
                          tableContent(widget.delPincode),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Post Office',
                          ),
                          tableContent(widget.delPostoffice),
                        ]),
                        TableRow(children: [
                          tableData(
                            'District',
                          ),
                          tableContent(widget.delDistrict),
                        ]),
                        TableRow(children: [
                          tableData(
                            'State',
                          ),
                          tableContent(widget.delState),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Delivery Date',
                          ),
                          tableContent(widget.deliveryDate),
                        ]),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Note- The product may be delivered before the given delivery date.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[300],
                          fontSize: 11),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'नोट- उत्पाद दी गई तारीख से पहले डिलीवर किया जा सकता है।',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[300],
                          fontSize: 11),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 2.6,
                    ),
                    Text(
                      'Transaction Details',
                      style: GoogleFonts.merienda(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16),
                    ),
                    Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: {0: FixedColumnWidth(140)},
                      children: [
                        TableRow(children: [
                          tableData(
                            'Payment Method:',
                          ),
                          tableContent('UPI(India)'),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Payment type: ',
                          ),
                          tableContent('Online'),
                        ]),
                        TableRow(children: [
                          tableData(
                            'UPI Id: ',
                          ),
                          tableContent(widget.upiId),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Transaction Id: ',
                          ),
                          tableContent(widget.transactionId),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Total Price:',
                          ),
                          tableContent('₹ ${widget.fare.toString()}'),
                        ]),
                        TableRow(children: [
                          tableData(
                            'Payment Status',
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              'Success',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )),
                          )
                        ]),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 3,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tableContent(String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ),
    );
  }
}

Widget tableData(String text) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Center(
      child: Text(text,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
    ),
  );
}

/*
const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Note- This form field is only for the delivery or receiving agent/person.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[300],
                          fontSize: 11),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'नोट- यह फ़ॉर्म फ़ील्ड केवल डिलीवरी या रिसीविंग एजेंट/व्यक्ति के लिए है।',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[300],
                          fontSize: 11),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Parcel Receiver Details'),
                            Text('[Date/Name/Sign]'),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 1,
                              width: 150,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 1,
                              width: 150,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 1,
                              width: 150,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Parcel Delivery details'),
                            Text('[Date/Name/Sign]'),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 1,
                              width: 150,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 1,
                              width: 150,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 1,
                              width: 150,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                   
                    Divider(
                      thickness: 2.0,
                      color: Colors.black,
                    ),
 const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Note- Before delivery, both the receiver and the delivery person must sign or fill in the required details. If either refuses to sign, please contact 139 and file a complaint.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[300],
                          fontSize: 11),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'नोट- डिलीवरी से पहले प्राप्तकर्ता और डिलीवरी कर्मी दोनों को साइन करना या आवश्यक विवरण भरना अनिवार्य है। यदि कोई भी साइन करने से मना करता है, तो कृपया 139 पर संपर्क करें और शिकायत दर्ज करें।',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[300],
                          fontSize: 11),
                      textAlign: TextAlign.start,
                    ),
 */
