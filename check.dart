import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class check extends StatefulWidget {
  check({Key key}) : super(key: key);

  @override
  _checkState createState() => _checkState();
}

class _checkState extends State<check> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 120),
        child: RaisedButton(
          onPressed: () async {
            String discoveredUserCNIC;
            String recordsTestResult;

            try {
              var discoveredUserRefernce =
                  _firestore.collection('users').doc('96922254');
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
                          //contactStatusText =
                          // 'You were in contact with an infected person';

                          //cameInContactWithInfected = true;
                        });
                      } else {
                        setState(() {
                          // contactStatusText = 'You are Safe';

                          //cameInContactWithInfected = false;
                        });
                        print(false);
                      }
                    },
                  );
                },
              );
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
              child: Text("Check",
                  style: TextStyle(
                    color: Colors.grey,
                  ))),
        ),
      ),
    );
  }
}
