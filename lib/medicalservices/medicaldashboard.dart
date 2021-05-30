import 'dart:ui';
import "package:flutter/material.dart ";
import 'mapBuilder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:covtrace/apikey.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MedicalServices extends StatefulWidget {
  @override
  _MedicalServicesState createState() => _MedicalServicesState();
}

class _MedicalServicesState extends State<MedicalServices> {
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
    } else {
      response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$type&location=$lat,$lng&rankby=distance&key=$mapAPIKey'));
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
        title: Text("Medical Services"),
        backgroundColor: Colors.redAccent,
      ),
      drawer: DrawerBuilder(),
      backgroundColor: Colors.redAccent.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
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
                        'hospital',
                        true);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapBuilder(
                                type: 'Nearby Hospitals',
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
                          Icons.local_hospital,
                          color: Colors.redAccent,
                          size: 70.0,
                        ),
                        Text(
                          'Hospitals',
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
                  onTap: () async {
                    //bd mein dekhna hai isayyyyy
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    List nearbyPlacesList = await getPlaces(
                        position.latitude.toString(),
                        position.longitude.toString(),
                        'Ambulance+Services',
                        false);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapBuilder(
                                type: 'Nearby Ambulance Services',
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
                          Icons.healing,
                          color: Colors.redAccent,
                          size: 70.0,
                        ),
                        Text(
                          'Ambulance Services',
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
                  onTap: () async {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    List nearbyPlacesList = await getPlaces(
                        position.latitude.toString(),
                        position.longitude.toString(),
                        'pharmacy',
                        true);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapBuilder(
                              currentLocation: position,
                              nearbyLocations: nearbyPlacesList,
                              type: 'Nearby Pharmacies')),
                    );
                  },
                  splashColor: Colors.redAccent,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_pharmacy,
                          color: Colors.redAccent,
                          size: 70.0,
                        ),
                        Text(
                          'Pharmacies',
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
                  onTap: () async {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    List nearbyPlacesList = await getPlaces(
                        position.latitude.toString(),
                        position.longitude.toString(),
                        'Sanitizing+and+Disinfectant+Service',
                        false);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapBuilder(
                              currentLocation: position,
                              nearbyLocations: nearbyPlacesList,
                              type: 'Nearby Disinfection Teams')),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            'Disinfectant Teams',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
