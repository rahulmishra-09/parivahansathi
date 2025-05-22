import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/dashboard/dashboard.dart';
import 'package:railway/setting/feedback_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Dashboard(),
                  fullscreenDialog: true,
                ));
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text(
            'S E T T I N G S',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () =>
                    _launchUrl('https://www.irctc.co.in/nget/enquiry/alerts'),
                child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications,
                    ),
                    title: Text(
                      'Alerts',
                      //style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    style: ListTileStyle.list,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              GestureDetector(
                onTap: () =>
                    _launchUrl('https://www.irctc.co.in/nget/enquiry/alerts'),
                child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(
                      Icons.browse_gallery,
                    ),
                    title: Text(
                      'Gallery',
                      //style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    style: ListTileStyle.list,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Center(
                            child: Text('This feature has not activated.'))),
                  );
                },
                child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(
                      Icons.rate_review,
                    ),
                    title: Text(
                      'Rate Us',
                      //style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    style: ListTileStyle.list,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FeedbackPage(),
                    fullscreenDialog: true,
                  ));
                },
                child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(
                      Icons.feedback,
                    ),
                    title: Text(
                      'Feedback',
                      //style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    style: ListTileStyle.list,
                  ),
                ),
              ),
              const SizedBox(height: 2,),
               Center(
                child: Container(
                  height: 500,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pages_design.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch this url';
    }
  }
}
