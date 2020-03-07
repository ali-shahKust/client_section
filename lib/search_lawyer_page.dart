import 'package:client_lawyer_project/client_login_page.dart';
import 'package:client_lawyer_project/describe_offer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client_lawyer_project/constant.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'Profile_edit.dart';
import 'chat_page.dart';
import 'client_session_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Search_Lawyer_Page extends StatefulWidget {
  Search_Lawyer_Page({Key key}) : super(key: key);

  // static final String path = "lib/src/pages/lists/list2.dart";

  _Search_Lawyer_PageState createState() => _Search_Lawyer_PageState();
}

class _Search_Lawyer_PageState extends State<Search_Lawyer_Page> {
  final primary = Constant.appColor;
  final secondary = Constant.appColor;
  final databaseReference = Firestore.instance;

  DocumentSnapshot myInfoRef;
  String myName = '';
  String abtMe = '';
  String myDp = '';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color active = Colors.white;
  final Color divider = Colors.white;

  @override
  void initState() {
    getData();
    myInfo();
    super.initState();
  }

  final List<Map> LawyerList = [];
  List<Map> _filteredList = List();

  _filterItems(String val) {
    _filteredList.clear();
    for (var i in LawyerList) {
      var name = i['username'].toString().toLowerCase();
      if (name == val || name.contains(val)) {
        _filteredList.add(i);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      key: _key,
      drawer: _buildDrawer(),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                LawyerList.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.only(top: 145),
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: _filteredList.isEmpty
                                ? LawyerList.length
                                : _filteredList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildList(context, index);
                            }),
                      )
                    : Container(
                        child: Center(
                          child: Text('No data'),
                        ),
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
                          child: Text('Client',
                              style: TextStyle(
                                  fontSize: 32,
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: TextField(
                            onChanged: (val) {
                              _filterItems(val);
                            },
                            // controller: TextEditingController(text: locations[0]),
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                                hintText: "Search Lawyer",
                                hintStyle: TextStyle(
                                    color: Colors.black38, fontSize: 16),
                                prefixIcon: Material(
                                  elevation: 0.0,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  child: Icon(Icons.search),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 13)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
      height: 210,
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
                  image: (_filteredList.isEmpty
                              ? LawyerList[index]['user_dp']
                              : _filteredList[index]['user_dp']) ==
                          null
                      ? AssetImage('images/1.jpg')
                      : NetworkImage(_filteredList.isEmpty
                          ? LawyerList[index]['user_dp']
                          : _filteredList[index]['user_dp']),
                  fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _filteredList.isEmpty
                      ? LawyerList[index]['username']
                      : _filteredList[index]['username'],
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
                      Icons.merge_type,
                      color: secondary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                        _filteredList.isEmpty
                            ? LawyerList[index]['type']
                            : _filteredList[index]['type'],
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.attach_money,
                      color: secondary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                        _filteredList.isEmpty
                            ? LawyerList[index]['fees']
                            : _filteredList[index]['fees'],
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
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
                      child: Text(
                          _filteredList.isEmpty
                              ? LawyerList[index]['description']
                              : _filteredList[index]['description'],
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3)),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Constant.appColor),
                      child: FlatButton(
                        child: Text(
                          "Send Offer",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                        onPressed: () {
                          setState(() {
                            print(LawyerList[index].toString());

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Describe_Offer(LawyerList[index])));
                          });
                        },
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  void getData() {
    databaseReference
        .collection("Lawyers")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => LawyerList.add(f.data));
      setState(() {});
    });
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

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
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
                            builder: (context) => Session_Page()));
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
