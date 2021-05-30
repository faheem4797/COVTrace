import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register.dart';
import 'userdashboard.dart';
import 'admin/login.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVTrace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 1;

  bool showSpinner = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  void nextScreen() async {
    setState(() {
      showSpinner = true;
    });
    String cnic = await getCNICFromLocalData();
    String id = await getIDFromLocalData();
    if (cnic != null && cnic != '@gmail.com' && id != null) {
      try {
        final newUser =
            await _auth.signInWithEmailAndPassword(email: cnic, password: id);
        if (newUser != null) {
          print("User is now Logged in");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserDashboard()),
          );
        }
      } catch (e) {
        print(e);
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterPage(title: 'Register Page')),
      );
    }
    setState(() {
      showSpinner = false;
    });
  }

  Future<String> getCNICFromLocalData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('cnic') != null) {
      return pref.getString('cnic') + '@gmail.com';
    } else {
      return null;
    }
  }

  Future<String> getIDFromLocalData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('randomID');
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i <= _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 7.0,
      width: isActive ? 24.5 : 16.5,
      decoration: BoxDecoration(
        color: isActive ? Color(0xffFC7BA8) : Colors.redAccent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Container(
                  color: Color(0xffF4F7FA),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                left: 5,
                              ),
                              child: RaisedButton(
                                color: Colors.redAccent,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Text(
                                  'Admin',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(
                                right: 5,
                              ),
                              child: RaisedButton(
                                color: Colors.redAccent,
                                onPressed: () {
                                  nextScreen();
                                },
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ]),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage("assets/images/3.png"),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "COVTrace",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 550.0,
                        child: PageView(
                          physics: ClampingScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, bottom: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Expanded(
                                      child: Image(
                                        image:
                                            AssetImage('assets/images/7.png'),
                                        height: 400.0,
                                        width: 650.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "COVTrace\n",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 20.0,
                                        height: 1,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'COVID-19 Tracker Launched To Alert You And Keep You Safe!',
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 20.0,
                                        height: 1,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, bottom: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image(
                                      image: AssetImage('assets/images/1.png'),
                                      height: 400.0,
                                      width: 450.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "COVTrace\n",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 20.0,
                                        height: 1,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'COVTrace App To Find Corona Virus!',
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 20.0,
                                        height: 1,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, bottom: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image(
                                      image: AssetImage("assets/images/9.png"),
                                      height: 400.0,
                                      width: 450.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "COVTrace\n",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 20.0,
                                        height: 1,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'An App That Connects The People With Health Services!',
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 20.0,
                                        height: 1,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                      _currentPage != _numPages
                          ? Expanded(
                              child: Align(
                                alignment: FractionalOffset.bottomRight,
                                child: FlatButton(
                                    padding: EdgeInsets.only(bottom: 20),
                                    onPressed: () {
                                      _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Next',
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 18.0,
                                            )),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.redAccent,
                                          size: 15.0,
                                        ),
                                      ],
                                    )),
                              ),
                            )
                          : Text("")
                    ],
                  ),
                )),
          ),
        ),
        bottomSheet: _currentPage == _numPages
            ? Container(
                height: 75,
                width: double.infinity,
                color: Colors.redAccent,
                child: GestureDetector(
                  onTap: () async {
                    nextScreen();
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 9.0),
                      child: Text("Get Started",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              )
            : Text(''));
  }
}
