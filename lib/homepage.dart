import 'package:client_lawyer_project/request_to_session.dart';
import 'package:client_lawyer_project/search_lawyer_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client_lawyer_project/constant.dart';
import 'package:client_lawyer_project/request_status.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'Profile_edit.dart';
import 'accepted_request.dart';
import 'client_login_page.dart';
import 'models/message.dart';

class ClientHomePage extends StatefulWidget {
  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {

  //Variables
  String mName = '';
  Message _message;
  String receiverUid;
  final primary = Constant.appColor;
  final secondary = Constant.appColor;
  String myName = '';
  String abtMe = '';
  String myDp = '';

  @override
  void initState() {
    getData();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color active = Colors.white;
  final Color divider = Colors.white;
//Home Screen Card
  Widget cards(image, title) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case "My Session":
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Request_toSession()));
            break;
          case "Request Status":
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Request_Page()));
            break;
          case "Chat":
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChatList()));
            break;
          case "View Lawyers":
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Search_Lawyer_Page()));
            break;
        }
      },
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0,
            ),
          ],
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                image,
                height: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Constant.appColor)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70.withOpacity(0.9),
        key: _key,
        drawer: _buildDrawer(),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  color: Constant.appColor,
                ),
                width: double.infinity,
              ),
              Container(
                margin: EdgeInsets.only(left: 90, bottom: 20),
                width: 299,
                height: 279,
                decoration: BoxDecoration(
                    color: Constant.appColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(160),
                        bottomLeft: Radius.circular(290),
                        bottomRight: Radius.circular(160),
                        topRight: Radius.circular(10))),
              ),
              CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
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

                              Column(
                                children: <Widget>[
                                  Text("Hello",
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white)
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25),
                                    child: Text(mName,
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white)),
                                  ),
                                ],
                              ),

                            ],
                          ),

                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(26.0),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 10,
                      children: <Widget>[
                        cards('images/wallet2.png', 'Request Status'),
                        cards('images/wallet3.png', 'My Session'),
                        cards('images/wallet3.png', 'Chat'),
                        cards('images/wallet2.png', 'View Lawyers'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
//Getting User details
  void getData() async {
    DocumentSnapshot mRef = await Firestore.instance
        .collection("Users")
        .document((await FirebaseAuth.instance.currentUser()).uid)
        .get();
    setState(() {
      mName = mRef['username'];
      myName = mRef['username'];
      abtMe = mRef['about_yourself'];
      myDp = mRef['user_dp'];
    });
  }
//Building Side Navigation Drawer
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatList()));
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
