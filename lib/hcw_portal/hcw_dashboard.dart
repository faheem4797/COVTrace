import 'dart:ui';
import "package:flutter/material.dart ";
import 'hcw_publications.dart';
import 'lodgings.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:covtrace/apikey.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HCWDashboard extends StatefulWidget {
  @override
  _HCWDashboardState createState() => _HCWDashboardState();
}

class _HCWDashboardState extends State<HCWDashboard> {
  Future<List> getPlaces(
      String lat, String lng, String type, bool typeSearch) async {
    String name;
    double latitude;
    double longitude;
    String placeID;
    var response;
    if (typeSearch) {
      response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=$type&rankby=distance&key=$mapAPIKey'));
    }
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      var jsonResults = json['results'] as List;
      print(jsonResults);
      print(jsonResults[0]);

      jsonResults.map((parsedJson) {
        name = parsedJson['name'];
        placeID = parsedJson['place_id'];
        latitude = parsedJson['geometry']['location']['lat'];
        longitude = parsedJson['geometry']['location']['lng'];
      }).toList();
      return jsonResults;
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HCW Dashboard"),
        backgroundColor: Colors.redAccent,
      ),
      drawer: DrawerBuilder(),
      backgroundColor: Colors.redAccent.shade100,
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 220),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          // childAspectRatio: 1.0,
          children: [
            Card(
              margin: EdgeInsets.all(7.0),
              child: InkWell(
                onTap: () async {
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  List nearbyPlacesList = await getPlaces(
                      position.latitude.toString(),
                      position.longitude.toString(),
                      'lodging',
                      true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HCWLodging(
                              type: 'Nearby Lodgings',
                              currentLocation: position,
                              nearbyLocations: nearbyPlacesList,
                            )),
                  );
                },
                splashColor: Colors.redAccent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hotel,
                        color: Colors.redAccent,
                        size: 70.0,
                      ),
                      Text(
                        'Nearby Lodgings',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(7.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Publications()),
                  );
                },
                splashColor: Colors.redAccent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.redAccent,
                        size: 70.0,
                      ),
                      Text(
                        'Health Publications',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.redAccent.shade100,
        child: ListView(
          children: [
            Container(
              color: Colors.redAccent,
              child: SizedBox(
                height: 170,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/3.png"),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("Profile"),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Help"),
              //tileColor: Colors.redAccent,
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text("FAQs"),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About Us"),
            ),
          ],
        ),
      ),
    );
  }
}
