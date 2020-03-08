import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client_lawyer_project/constant.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'Profile_edit.dart';
import 'accepted_request.dart';
import 'client_chat_page.dart';
import 'client_login_page.dart';

class Request_toSession extends StatefulWidget {
  Request_toSession({Key key}) : super(key: key);
  static final String path = "lib/src/pages/lists/list2.dart";

  _Request_toSessionState createState() => _Request_toSessionState();
}

class _Request_toSessionState extends State<Request_toSession> {
  final primary = Constant.appColor;
  final secondary = Constant.appColor;
  final databaseReference = Firestore.instance;
  final List<DocumentSnapshot> LawyerList = [
  ];
  String myName = '';
  String abtMe = '';
  String myDp = '';

  DocumentSnapshot myInfoRef;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color active = Colors.white;
  final Color divider = Colors.white;

  @override
  void initState() {
    getData();
    myInfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      key: _key,
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 145),
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: LawyerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildList(context, index);
                    }),
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),

                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _key.currentState.openDrawer();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Text('Aproved To Session',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 110,
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 130,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 3, color: secondary),
              image: DecorationImage(
                  image:LawyerList[index]['lawyer_dp'] == null? AssetImage('/images/3.jpg') : NetworkImage(LawyerList[index]['lawyer_dp']),
                  fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  LawyerList[index]['lawyer_name'],
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 6,
                ),

                Row(
                  children: <Widget>[
                    Icon(
                      Icons.description,
                      color: secondary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(LawyerList[index]['description'],
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  void myInfo() async {
    myInfoRef = await Firestore.instance
        .collection("Users")
        .document((await FirebaseAuth.instance.currentUser()).uid)
        .get();
    setState(() {
      myName = myInfoRef['username'];
      abtMe = myInfoRef['about_yourself'];
      myDp = myInfoRef['user_dp'];
    });
  }

  void getData() async {
    String uId = (await FirebaseAuth.instance.currentUser()).uid;
    databaseReference
        .collection("My Session").where('client_uid', isEqualTo: uId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => LawyerList.add(f));
      print('my list of data $LawyerList');
      setState(() {});
    });
  }

  void saveSession(DocumentSnapshot sessionShot ,int index) {
    Firestore.instance
        .collection('start_chat')
        .add(sessionShot.data)
        .then((sVal){
      deleteData(sessionShot.documentID, index);
    });
  }


  void deleteData(String documentId, int index) {
    try {
      databaseReference
          .collection('My Session')
          .document(documentId)
          .delete().then(
              (val) {
            setState(() {
              LawyerList.removeAt(index);
            });
          });
    } catch (e) {
      print(e.toString());
    }
  }

  _buildDrawer() {
    final String image = "images/1.jpg";
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 40),
        decoration: BoxDecoration(
            color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
        width: 300,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                      LinearGradient(colors: [active, Colors.white30])),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: myDp == null
                        ? AssetImage('/images/1.jpg')
                        : NetworkImage(myDp),
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  myName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                ),
                abtMe == null
                    ? Text('No Details')
                    : Text(
                  abtMe,
                  style: TextStyle(color: active, fontSize: 16.0),
                ),
                SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatList()));
                  },
                  child: _buildRow(
                    Icons.message,
                    "Chat",
                  ),
                ),
                _buildDivider(),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile_Setting()));
                    },
                    child: _buildRow(
                      Icons.face,
                      "Edit profile",
                    )),
                _buildDivider(),
                GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Client_Login()));
                    },
                    child: _buildRow(
                      Icons.label_outline,
                      "Logout",
                    )),
                _buildDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: [
        Icon(
          icon,
          color: active,
        ),
        SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
        Spacer(),
      ]),
    );
  }
}
