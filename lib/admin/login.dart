import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool error = false;
  bool showSpinner = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100,
      appBar: AppBar(
        title: Text("Admin"),
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
                radius: 65.0,
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
                            keyboardType: TextInputType.emailAddress,
                            cursorHeight: 15,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Email",
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
                              this.email = input;
                              RegExp regExp = new RegExp(
                                r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                                caseSensitive: true,
                                multiLine: false,
                              );

                              if (!regExp.hasMatch(input)) {
                                return "Incorrect Email";
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                this.email = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            cursorHeight: 15,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Password",
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
                              this.password = input;
                              if (input.isEmpty) {
                                return "Password could not be empty";
                              }
                              if (input.length < 6) {
                                return "Password should be atleast 6 characters long.";
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                this.password = value;
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
                height: 45.0,
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        if (email != null && password != null) {
                          setState(() {
                            showSpinner = true;
                          });
                          final newUser =
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: this.password);

                          if (newUser != null) {
                            print("Admin is now Logged in");
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminDashboard()),
                            );
                          }

                          setState(() {
                            showSpinner = false;
                            email = '';
                            password = '';
                          });
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                          error = true;
                          showSpinner = false;
                        });
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
                          child: Text("     Login",
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              error == true
                  ? Text('Login Failed. Please try again',
                      style: TextStyle(color: Colors.red))
                  : Text(''),
            ],
          ),
        ),
      ),
    );
  }
}
