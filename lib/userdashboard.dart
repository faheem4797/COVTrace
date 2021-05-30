import 'dart:ui';

import 'package:covtrace/hcw_portal/hcw_dashboard.dart';
import "package:flutter/material.dart ";
import 'tracing/contact_tracing.dart';
import 'medicalservices/medicaldashboard.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.redAccent,
      ),
      drawer: DrawerBuilder(),
      backgroundColor: Colors.redAccent.shade100,
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 60),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          // childAspectRatio: 1.0,
          children: [
            Card(
              margin: EdgeInsets.all(7.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MedicalServices()),
                  );
                },
                splashColor: Colors.redAccent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.medical_services_outlined,
                        color: Colors.redAccent,
                        size: 70.0,
                      ),
                      Text(
                        "Nearby Medical Services",
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
                    MaterialPageRoute(builder: (context) => StartTracing()),
                  );
                },
                splashColor: Colors.redAccent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.supervised_user_circle,
                        color: Colors.redAccent,
                        size: 70.0,
                      ),
                      Text(
                        'User Status',
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
                onTap: () {},
                splashColor: Colors.redAccent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.new_releases_sharp,
                        color: Colors.redAccent,
                        size: 70.0,
                      ),
                      Text(
                        'News & Statistics',
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
                onTap: () {},
                splashColor: Colors.redAccent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        color: Colors.redAccent,
                        size: 70.0,
                      ),
                      Text(
                        'Home Delivery & Vaccination',
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
                onTap: () {},
                splashColor: Colors.redAccent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat,
                        color: Colors.redAccent,
                        size: 70.0,
                      ),
                      Text(
                        'Chatbot',
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
                    MaterialPageRoute(builder: (context) => HCWDashboard()),
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
                        'HCW Portal',
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
