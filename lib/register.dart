import 'userdashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({this.title});
  final String title;

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cnic;
  String _tempcnic;
  String randomID;
  bool showSpinner = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void randomNumberGenerator() {
    Random random = new Random();
    setState(() {
      randomID = (random.nextInt(99999999) + 11111111)
          .toString(); // from 11111111 upto 99999999 included
    });
  }

  Future<void> setToLocalData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('cnic', cnic);
    pref.setString('randomID', randomID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100,
      appBar: AppBar(
        title: Text("User Registeration "),
        backgroundColor: Colors.redAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/5.png'),
                radius: 120.0,
                backgroundColor: Colors.redAccent[100],
              ),
              SizedBox(height: 20.0),
              Center(
                child: Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.numberWithOptions(),
                            cursorHeight: 22,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Enter CNIC",
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              suffixIcon: Icon(
                                Icons.perm_identity,
                                color: Colors.red,
                              ),
                            ),
                            validator: (input) {
                              RegExp regExp = new RegExp(
                                r"^[0-9]{5}[0-9]{7}[0-9]$",
                                caseSensitive: false,
                                multiLine: false,
                              );
                              this.cnic = input;
                              if (input.isEmpty) {
                                return "CNIC could not be empty";
                              }
                              if (!regExp.hasMatch(input)) {
                                return "Please enter your 13 digit CNIC number without any dashes";
                              }
                            },
                            onSaved: (value) {
                              String ender = '@gmail.com';
                              setState(() {
                                this.cnic = value;
                                _tempcnic = value + ender;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: 127.0,
                height: 50.0,
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      print(this.cnic);
                      print(this._tempcnic);
                      // Navigate to new screen

                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        randomNumberGenerator();
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: _tempcnic, password: randomID);
                        if (newUser != null) {
                          print("New User registered");
                          _firestore
                              .collection('users')
                              .doc(randomID)
                              .set({'cnic': cnic});
                          await setToLocalData();
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserDashboard()),
                          );
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'email-already-in-use') {
                          print('The account already exists for that CNIC.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: <Widget>[
                      Center(
                          child: Text("Register",
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
