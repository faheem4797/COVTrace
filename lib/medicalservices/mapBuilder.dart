import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:covtrace/apikey.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapBuilder extends StatefulWidget {
  Position currentLocation;
  List nearbyLocations;
  String type;
  MapBuilder(
      {@required this.currentLocation,
      @required this.nearbyLocations,
      @required this.type});
  @override
  MapBuilderState createState() => MapBuilderState(
      currentUserLocation: currentLocation,
      nearbyPlaces: nearbyLocations,
      typeOption: type);
}

class MapBuilderState extends State<MapBuilder> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> markersList;
  String typeOption;
  List nearbyPlaces;
  Position currentUserLocation;
  String name;
  String vicinity;
  String address;
  String phoneNumber;
  String website;
  MapBuilderState(
      {@required this.currentUserLocation,
      @required this.nearbyPlaces,
      @required typeOption});

  Future<void> getPlacesDetails(String placeid) async {
    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeid&fields=formatted_phone_number,website,formatted_address,name,vicinity&key=$mapAPIKey'));
    if (response.statusCode == 200) {
      print(response.body);

      var json = convert.jsonDecode(response.body);
      print(json);
      var parsedJson = json['result'];
      print(parsedJson);
      setState(() {
        name = parsedJson['name'];
        print(name);
        vicinity = parsedJson['vicinity'];
        address = parsedJson['formatted_address'] != null
            ? parsedJson['formatted_address']
            : null;
        phoneNumber = parsedJson['formatted_phone_number'] != null
            ? parsedJson['formatted_phone_number']
            : null;
        website = parsedJson['website'] != null ? parsedJson['website'] : null;
      });
    } else {
      print(response.statusCode);
    }
  }

  void getMarkers(List places) async {
    var markers = List<Marker>();

    await places.forEach((place) {
      Marker marker = Marker(
        markerId: MarkerId(place['name']),
        draggable: false,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: place['name']),
        position: LatLng(place['geometry']['location']['lat'],
            place['geometry']['location']['lng']),
        onTap: () async {
          await getPlacesDetails(place['place_id']);
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.redAccent.shade100,
                    body: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              title: Text('$name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20)),
                              trailing: SizedBox(
                                height: 25,
                              ),
                              subtitle: Text('$vicinity',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            Divider(
                              color: Colors.black26,
                              thickness: 2,
                            ),
                            ListTile(
                              leading: Icon(Icons.location_on,
                                  color: Colors.white, size: 25),
                              title: Text(
                                  address != null
                                      ? '$address'
                                      : 'No Address available',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            Divider(
                              color: Colors.black26,
                              thickness: 2,
                            ),
                            ListTile(
                              leading: Icon(Icons.phone,
                                  color: Colors.white, size: 25),
                              title: Text(
                                  phoneNumber != null
                                      ? '$phoneNumber'
                                      : 'No Phone Number Available',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            Divider(
                              color: Colors.black26,
                              thickness: 2,
                            ),
                            ListTile(
                              leading: Icon(Icons.link,
                                  color: Colors.white, size: 25),
                              title: Text(
                                  website != null
                                      ? '$website'
                                      : 'No Website available',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            Divider(
                              color: Colors.black26,
                              thickness: 2,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      );

      markers.add(marker);
    });
    setState(() {
      markersList = markers;
    });
  }

  @override
  void initState() {
    getMarkers(nearbyPlaces);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25.0,
          ),
        ),
        title: Text(widget.type),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
        ],
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        myLocationEnabled: true,
        rotateGesturesEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(
                currentUserLocation.latitude, currentUserLocation.longitude),
            zoom: 13),
        onMapCreated: (GoogleMapController controller) {
          getMarkers(nearbyPlaces);
          _controller.complete(controller);
        },
        markers: (Set<Marker>.of(markersList)),
      ),
    );
  }
}
