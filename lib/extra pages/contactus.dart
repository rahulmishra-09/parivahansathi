import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Contactus extends StatelessWidget {
  const Contactus({super.key});

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black45);
    var headTextStyle = GoogleFonts.dmMono(
        fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold);

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          'CONTACT US',
          style: GoogleFonts.dmSans(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('For Railway(IRCTC)', style: headTextStyle),
            Text(
              'Customer Care Numbers: 14646 / 08044647999 / 08035734999',
              style: textStyle,
            ),
            Text(
              'Language: Hindi, English',
              style: textStyle,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'For Admin',
              style: headTextStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.email),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Email: ',
                  style: textStyle,
                ),
                Text(
                  'parivahansathi@transpo.com',
                  style: textStyle,
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Icon(Icons.phone),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Contact Number: ',
                  style: textStyle,
                ),
                Text(
                  '8002426276',
                  style: textStyle,
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Flexible(
                child: Text(
              'Registered Office - Corporate Office',
              textAlign: TextAlign.start,
              style: headTextStyle,
            )),

            Row(
              children: [
                Flexible(
                  child: Text(
                    '► ParivahanSathi and Booking Corporation Ltd.',
                    style: textStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0,),
            Row(
              children: [
                Flexible(
                  child: Text(
                      '► 3rd Floor, VTP Tower-X, Pramukh Park, Nr. BRTS Pandesara G.I.D.C, Pandesara, Surat.', style: textStyle,),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
