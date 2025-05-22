import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});
  @override
  Widget build(BuildContext context) {
    var titleText = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.redAccent,
    );
    var subtitleText = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text('E M E R G E N C Y'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Card(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(
                    'Railway Police (RPF)',
                    style: titleText,
                  ),
                  subtitle: Text(
                    'For theft, crime, or suspicious activity.',
                    style: subtitleText,
                  ),
                  trailing: Icon(Icons.call),
                  onTap: ()=> launchUrlPhone('139'),
                ),
              ),
              const SizedBox(height: 8.0,),
              Card(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(
                    'Medical Emergency',
                    style: titleText,
                  ),
                  subtitle: Text(
                    'For medical assistance at stations or trains',
                    style: subtitleText,
                  ),
                  trailing: Icon(Icons.call),
                  onTap: ()=> launchUrlPhone('102'),
                ),
              ),
              const SizedBox(height: 8.0,),
              Card(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(
                    'Fire Department',
                    style: titleText,
                  ),
                  subtitle: Text(
                    'For fire-related emergencies',
                    style: subtitleText,
                  ),
                  trailing: Icon(Icons.call),
                  onTap: ()=> launchUrlPhone('101'),
                ),
              ),
              const SizedBox(height: 8.0,),
              Card(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(
                    'Train Accident/Derailment',
                    style: titleText,
                  ),
                  subtitle: Text(
                    'Report train accidents or derailments',
                    style: subtitleText,
                  ),
                  trailing: Icon(Icons.call),
                  onTap: ()=> launchUrlPhone('138'),
                ),
              ),
              const SizedBox(height: 8.0,),
              Card(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(
                    'Police Emergency',
                    style: titleText,
                  ),
                  subtitle: Text(
                    'For general emergency or crime near railway',
                    style: subtitleText,
                  ),
                  trailing: Icon(Icons.call),
                  onTap: ()=> launchUrlPhone('100'),
                ),
              ),
              const SizedBox(height: 8.0,),
              const SizedBox(height: 8.0,),
              Card(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(
                    'Lost and Found',
                    style: titleText,
                  ),
                  subtitle: Text(
                    'For reporting lost items or missing persons',
                    style: subtitleText,
                  ),
                  trailing: Icon(Icons.call),
                  onTap: ()=> launchUrlPhone('139'),
                ),
              ),
              const SizedBox(height: 8.0,),
              Card(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(
                    'National Disaster Management',
                    style: titleText,
                  ),
                  subtitle: Text(
                    'For disaster-related emergencies',
                    style: subtitleText,
                  ),
                  trailing: Icon(Icons.call),
                  onTap: ()=> launchUrlPhone('108'),
                ),
              ),
              const SizedBox(height: 8.0,),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> launchUrlPhone(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    if(!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch this url.";
    }
  }
}