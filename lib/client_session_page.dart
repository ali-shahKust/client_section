import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client_lawyer_project/constant.dart';

import 'client_chat_page.dart';


class Session_Page extends StatefulWidget {
  Session_Page({Key key}) : super(key: key);
  static final String path = "lib/src/pages/lists/list2.dart";

  _Session_PageState createState() => _Session_PageState();
}

class _Session_PageState extends State<Session_Page> {
  final primary =Constant.appColor;
  final secondary = Constant.appColor;
  final databaseReference = Firestore.instance;
  String dId='';

  final List<DocumentSnapshot> LawyerList = [
  ];

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 145),
                height: MediaQuery.of(context).size.height,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Text('Sessions',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)
                    ),
                  ),
                ),
              ),
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
      height: 200,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          Container(
//            width: 50,
//            height: 50,
//            margin: EdgeInsets.only(right: 15),
//            decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(50),
//              border: Border.all(width: 3, color: secondary),
//              image: DecorationImage(
//                  image: NetworkImage(LawyerList[index]['user_dp']),
//                  fit: BoxFit.fill),
//            ),
//          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                Text(
//                  LawyerList[index]['username'],
//                  style: TextStyle(
//                      color: primary,
//                      fontWeight: FontWeight.bold,
//                      fontSize: 18),
//                ),
//                SizedBox(
//                  height: 6,
//                ),
//                Row(
//                  children: <Widget>[
//                    Icon(
//                      Icons.merge_type,
//                      color: secondary,
//                      size: 20,
//                    ),
//                    SizedBox(
//                      width: 5,
//                    ),
//                  ],
//                ),
//                SizedBox(
//                  height: 6,
//                ),

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
                    Text(LawyerList[index]['description'],
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                Padding(
                    padding:EdgeInsets.only(top: 35),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Constant.appColor),
                      child: FlatButton(
                        child: Text(
                          "Start Session",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder:(context) => ChatScreen(
                              name: LawyerList[index].data['username'],
                              photoUrl: LawyerList[index].data['user_dp'],
                              receiverUid:
                              LawyerList[index].data['lawyer_uid']
                          )));
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

  void getData() async {
    String uId = (await FirebaseAuth.instance.currentUser()).uid;
    databaseReference
        .collection("My Session").where('client_uid', isEqualTo: uId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => LawyerList.add(f));

      setState(() {});
    });
  }

}
