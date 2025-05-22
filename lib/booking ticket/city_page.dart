import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railway/database/firestore_service.dart';

class CityPage extends StatefulWidget {
  final String? excludeCity;
  const CityPage({super.key, this.excludeCity});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  final _searchBar = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  String query = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.grey[700],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, bottom: 15.0, top: 10.0),
              child: SearchBar(
                autoFocus: true,
                controller: _searchBar,
                hintText: 'Search Station',
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                onChanged: (value) {
                  setState(() {
                    query = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
                child: query.isEmpty
                    ? Center(
                        child: Text(
                          'Search for a station...',
                          style: GoogleFonts.merienda(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                        ),
                      )
                    : StreamBuilder(
                        stream: firestoreService.getStationDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          } else if (!snapshot.hasData &&
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No Station Found...',
                                style: GoogleFonts.merienda(
                                    color: Colors.deepOrangeAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            );
                          }

                          List<Map<String, dynamic>> stationList =
                              snapshot.data!.docs.map((doc) {
                            return doc.data() as Map<String, dynamic>;
                          }).toList();

                          List<Map<String, dynamic>> filterStations =
                              stationList.where((station) {
                            String stationCode =
                                (station['stationcode'] ?? '').toLowerCase();
                            String stationName =
                                (station['stationname'] ?? '').toLowerCase();
                            String cityName =
                                (station['cityname'] ?? '').toLowerCase();
                            return stationCode.contains(query.toLowerCase()) ||
                                stationName.contains(query.toLowerCase()) ||
                                cityName.contains(query.toLowerCase());
                          }).toList();

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: filterStations.length,
                              itemBuilder: (context, index) {
                                final station = filterStations[index];
                                return Container(
                                  margin: EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.grey[200],
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.train,
                                      color: Colors.black,
                                      size: 28,
                                    ),
                                    title: Flexible(
                                        child: Text(
                                            '${station['stationcode']}-${station['stationname']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87))),
                                    subtitle: Text(
                                      '${station['cityname']}',
                                      style: TextStyle(
                                          color: Colors.grey.shade800),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop(
                                          "${station['stationcode']}-${station['stationname']}");
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }))
          ],
        ),
      ),
    );
  }
}
