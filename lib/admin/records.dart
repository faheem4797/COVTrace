import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';

class AdminCOVIDRecords extends StatefulWidget {
  @override
  _AdminCOVIDRecordsState createState() => _AdminCOVIDRecordsState();
}

class _AdminCOVIDRecordsState extends State<AdminCOVIDRecords> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String cnic;
  String testResult;
  bool spinner = false;

  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('records');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100,
      appBar: AppBar(
        title: Text('COVID Records'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              await buildShowModalBottomSheet(context, 'add', true, null);
            },
          )
        ],
      ),
      drawer: AdminDrawerBuilder(),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: collectionReference.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ModalProgressHUD(
                    inAsyncCall: spinner,
                    child: Container(
                      child: ListView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                        children: snapshot.data.docs
                            .map((currentDoc) => Column(
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        await buildShowModalBottomSheet(context,
                                            'update', false, currentDoc);
                                      },
                                      onLongPress: () {
                                        collectionReference
                                            .doc(currentDoc.id)
                                            .delete();
                                      },
                                      title: Text(currentDoc['cnic'],
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      trailing: Text(currentDoc['result'],
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                    ),
                                    Divider(
                                      color: Colors.black26,
                                      thickness: 2,
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  buildShowModalBottomSheet(BuildContext context, String funcString, bool read,
      QueryDocumentSnapshot currentDoc) async {
    String tempCNIC;
    String tempTestResult;
    if (currentDoc != null) {
      tempCNIC = currentDoc['cnic'];
      tempTestResult = currentDoc['result'];
      print(tempTestResult);
      print(tempCNIC);
    }
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.redAccent.shade100,
              body: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 100),
                          child: TextFormField(
                            enabled: read,
                            initialValue: tempCNIC,
                            keyboardType: TextInputType.numberWithOptions(),
                            cursorHeight: 22,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "CNIC",
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            validator: (input) {
                              RegExp regExp = new RegExp(
                                r"^[0-9]{5}[0-9]{7}[0-9]$",
                                caseSensitive: false,
                                multiLine: false,
                              );
                              this.cnic = input;
                              if (!regExp.hasMatch(input)) {
                                return "Please enter your 13 digit CNIC number without any dashes";
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 20),
                          child: TextFormField(
                            initialValue: tempTestResult,
                            keyboardType: TextInputType.text,
                            cursorHeight: 22,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Test Result",
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            validator: (input) {
                              this.testResult = input.toLowerCase();
                              if (!(testResult == 'positive' ||
                                  testResult == 'negative')) {
                                return "Please enter either positive or negative";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 127.0,
                          height: 45.0,
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                print(testResult);
                                print(cnic);
                                try {
                                  if (funcString == 'add') {
                                    await collectionReference.add(
                                      {
                                        'cnic': cnic,
                                        'result': testResult,
                                        'time': FieldValue.serverTimestamp()
                                      },
                                    );
                                  } else if (funcString == 'update') {
                                    await collectionReference
                                        .doc(currentDoc.id)
                                        .update({
                                      'cnic': cnic,
                                      'result': testResult,
                                      'time': FieldValue.serverTimestamp()
                                    });
                                  }

                                  Navigator.pop(context);
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                            padding: funcString == 'add'
                                ? EdgeInsets.symmetric(horizontal: 24)
                                : EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: <Widget>[
                                Center(
                                    child: funcString == 'add'
                                        ? Text(" Add Record",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ))
                                        : Text('  Update Record',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
