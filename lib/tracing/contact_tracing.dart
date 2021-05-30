import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covtrace/userdashboard.dart';
import 'package:nearby_connections/nearby_connections.dart';

class StartTracing extends StatefulWidget {
  StartTracing({Key key}) : super(key: key);

  @override
  _StartTracingState createState() => _StartTracingState();
}

class _StartTracingState extends State<StartTracing> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Strategy strategy = Strategy.P2P_STAR;
  bool contactStatusText = true;
  bool infected = false;
  Future<String> getIDFromLocalData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('randomID');
  }

  Future<String> getCNICFromLocalData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getString('cnic');
  }

  Future<void> advertiseForDevices() async {
    try {
      try {
        bool a = await Nearby().startAdvertising(
          await getIDFromLocalData(),
          strategy,
          onConnectionInitiated: null,
          onConnectionResult: (id, status) {
            print(status);
          },
          onDisconnected: (id) {
            print('Disconnected from advertiser with $id');
          },
          serviceId: "com.pkmnapps.covtrace",
        );

        print('ADVERTISING ${a.toString()}'); //prints either true or false
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> discoverDevices() async {
    String currentUserID = await getIDFromLocalData();
    try {
      bool a = await Nearby().startDiscovery(
        currentUserID,
        strategy,
        onEndpointFound: (id, name, serviceId) async {
          print(
              'I saw id:$id with name:$name'); // the name here is the randomID of user also set as document ID in firestore

          var userReference = _firestore.collection('users').doc(currentUserID);

          //  On discovering a device, randomID(name here) will be saved with CNIC
          await userReference.collection('contacts').doc(name).set({
            //name here is the randomID of user generated earlier
            'cnic': await getCNICFromID(randomID: name),
            'contact time': DateTime.now(),
            //In the 'users' collection with a documnetID (which is random ID) a new collection 'contacts' will be created which will save
          });
          await checkForContactWithInfected(name);
        },
        onEndpointLost: (id) {
          print(id);
        },
        serviceId: "com.pkmnapps.covtrace",
      );
      print('DISCOVERING: ${a.toString()}'); // prints either true or false
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkForContactWithInfected(discoveredUserID) async {
    String discoveredUserCNIC;
    String recordsTestResult;
    try {
      var discoveredUserRefernce =
          _firestore.collection('users').doc(discoveredUserID);
      await discoveredUserRefernce
          .get()
          .then<dynamic>((DocumentSnapshot snapshot) async {
        dynamic data = snapshot.data();
        discoveredUserCNIC = data['cnic'];
        print(discoveredUserCNIC);
      });
      await _firestore.collection('records').get().then(
        (recordsDocuments) {
          recordsDocuments.docs.forEach(
            (document) {
              var temp = document.data();
              String recordsCNIC = temp['cnic'];
              recordsTestResult = temp['result'];
              print(recordsCNIC);
              print(recordsTestResult);

              if (recordsCNIC == discoveredUserCNIC &&
                  recordsTestResult == 'positive') {
                print(true);
                setState(() {
                  contactStatusText = false;

                  //cameInContactWithInfected = true;
                });
              } else {
                print(false);
              }
            },
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkYourOwnStatus() async {
    String currentUserCNIC = await getCNICFromLocalData();
    await _firestore.collection('records').get().then(
      //Getting all documents from 'records' collection
      (recordsDocuments) {
        recordsDocuments.docs.forEach(
          // Loop
          (document) {
            var temp = document.data();
            String recordsCNIC = temp['cnic'];
            String recordsTestResult = temp['result'];
            print(recordsCNIC);
            print(recordsTestResult);

            // If Discovered User is Positive isinfected will be true else false
            if (recordsCNIC == currentUserCNIC &&
                recordsTestResult == 'positive') {
              print(true);
              setState(() {
                infected = true;
                //cameInContactWithInfected = true;
              });
              return;
            } else {
              print(false);
            }
          },
        );
      },
    );
  }

  void getPermissions() {
    Nearby().askLocationPermission();
  }

  Future<String> getCNICFromID({String randomID}) async {
    String res = '';
    await _firestore.collection('users').doc(randomID).get().then((doc) {
      if (doc.exists) {
        res = doc['cnic'];
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    });
    return res;
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
    checkYourOwnStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Status"),
        backgroundColor: Colors.redAccent,
      ),
      drawer: DrawerBuilder(),
      backgroundColor: Colors.redAccent.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 120),
            child: RaisedButton(
              onPressed: () async {
                await advertiseForDevices();
                await discoverDevices();
                if (!contactStatusText) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('You were in contact with an infected person'),
                    backgroundColor: Colors.orange.shade700,
                  ));
                }
              },
              padding: EdgeInsets.only(left: 20),
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                  child: Text("Start Tracing",
                      style: TextStyle(
                        color: Colors.white,
                      ))),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 120),
            child: RaisedButton(
              onPressed: () async {
                try {
                  await Nearby().stopDiscovery();
                  await Nearby().stopAdvertising();
                } catch (e) {
                  print(e);
                }
              },
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                  child: Text("Stop Tracing",
                      style: TextStyle(
                        color: Colors.white,
                      ))),
            ),
          ),
          infected == true ? Text('You are COVID Positive') : Text(''),
        ],
      ),
    );
  }
}
