import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'records.dart';
import 'publications.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
      drawer: AdminDrawerBuilder(),
      backgroundColor: Colors.redAccent.shade100,
      body: Container(
        padding: EdgeInsets.all(50.0),
        child: GridView.count(
          crossAxisCount: 1,
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
                    MaterialPageRoute(
                        builder: (context) => AdminCOVIDRecords()),
                  );
                },
                splashColor: Colors.redAccent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.storage,
                        color: Colors.redAccent,
                        size: 70.0,
                      ),
                      Text(
                        "Records",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
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
                    MaterialPageRoute(
                        builder: (context) => AdminPublications()),
                  );
                },
                splashColor: Colors.redAccent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pageview,
                        color: Colors.redAccent,
                        size: 70.0,
                      ),
                      Text(
                        "Publications",
                        style: TextStyle(fontSize: 20.0),
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

class AdminDrawerBuilder extends StatelessWidget {
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
