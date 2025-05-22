import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class GeneratePdf {
  static Future<Uint8List> generateTicket({
    required String trainName,
    required String trainNo,
    required String fromStation,
    required String destination,
    required String boardingStation,
    required String boardingDate,
    required String irctcUsername,
    required String email,
    required String phone,
    required String roomNo,
    required String village,
    required String pincode,
    required String postoffice,
    required String district,
    required String state,
    required String pickupDate,
    required String deliveryDate,
    required String delRoom,
    required String delVillage,
    required String delPincode,
    required String delPostoffice,
    required String delDistrict,
    required String delState,
    required String upiId,
    required String transactionId,
    required int fare,
    final String? landMark,
    final String? dropLandMark,
    required List<Map<String, dynamic>> productDetails,
  }) async {
    final pdf = pw.Document();

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
              child: pw.Text(cell, style: const pw.TextStyle(fontSize: 10)),
            );
          }).toList());
        }).toList(),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text('Parcel Ticket',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 2.6),
          buildTableRow('IRCTC Username:', irctcUsername),
          buildTableRow('Email:', email),
          buildTableRow('Phone:', phone),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 2.6),
          buildSectionTitle('Product Details'),
          pw.SizedBox(height: 5),
          pw.Container(
            color: PdfColors.grey300,
            padding: const pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: productDetails.map((product) {
                return pw.Text(
                  '${product['name'].toString().toUpperCase()} → [Weight-${product['weight']}], (Qty- ${product['number']})',
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
            ['Room/Plot No:', roomNo],
            ['Village', village.toUpperCase()],
            [
              'LandMark',
              landMark != null && landMark.isNotEmpty ? landMark : 'No Data'
            ],
            ['Pin Code', pincode],
            ['Post Office', postoffice],
            ['District', district],
            ['State', state],
            ['Pickup Date', pickupDate],
          ]),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 2.6),
          buildSectionTitle('Drop Location'),
          pw.SizedBox(height: 5),
          buildTable([
            ['Room/Plot No:', delRoom],
            ['Village', delVillage.toUpperCase()],
            [
              'LandMark',
              dropLandMark != null && dropLandMark.isNotEmpty
                  ? dropLandMark
                  : 'No Data'
            ],
            ['Pin Code', delPincode],
            ['Post Office', delPostoffice],
            ['District', delDistrict],
            ['State', delState],
            ['Delivery Date', deliveryDate],
          ]),
          pw.SizedBox(height: 5),
          pw.Text(
            'Note- The product may be delivered before the given delivery date.',
            style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
          ),
          pw.Text(
            'नोट- उत्पाद दी गई तारीख से पहले डिलीवर किया जा सकता है।',
            style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
          ),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 2.6),
          buildSectionTitle('Transaction Details'),
          pw.SizedBox(height: 5),
          buildTable([
            ['Payment Method:', 'UPI(India)'],
            ['Payment Type:', 'Online'],
            ['UPI ID:', upiId],
            ['Transaction ID:', transactionId],
            ['Total Price:', '₹ $fare'],
            ['Payment Status', 'Success'],
          ]),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 2.6),
          pw.Text(
            'Note- This form field is only for the delivery or receiving agent/person.',
            style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
          ),
          pw.Text(
            'नोट- यह फ़ॉर्म फ़ील्ड केवल डिलीवरी या रिसीविंग एजेंट/व्यक्ति के लिए है।',
            style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
          ),
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
          pw.Text(
            'नोट- डिलीवरी से पहले प्राप्तकर्ता और डिलीवरी कर्मी दोनों को साइन करना या आवश्यक विवरण भरना अनिवार्य है। यदि कोई भी साइन करने से मना करता है, तो कृपया 139 पर संपर्क करें और शिकायत दर्ज करें।',
            style: pw.TextStyle(color: PdfColors.red300, fontSize: 10),
          ),
          pw.SizedBox(height: 20),
          pw.Divider(thickness: 2.0, color: PdfColors.black),
        ],
      ),
    );

    return pdf.save();
  }
}
