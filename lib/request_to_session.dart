import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client_lawyer_project/constant.dart';

import 'client_chat_page.dart';

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

  @override
  void initState() {
    getData();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Text('Request Aprroved to Session',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)
                    ),
                  ),
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
      height: 150,
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
                      Icons.merge_type,
                      color: secondary,
                      size: 20,
                    ),


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
                    Text(LawyerList[index]['description'],
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
//                Row(
//                  children: <Widget>[
//                    Padding(
//                        padding: EdgeInsets.only(top: 35),
//                        child: Container(
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.all(
//                                  Radius.circular(10)),
//                              color: Constant.appColor),
//                          child: FlatButton(
//                            child: Text(
//                              "Start Session",
//                              style: TextStyle(
//                                  color: Colors.white,
//                                  fontWeight: FontWeight.w700,
//                                  fontSize: 18),
//                            ),
//                            onPressed: () {
//                              saveSession(LawyerList[index],index);
//                              Navigator.push(context, MaterialPageRoute(builder:(context) => ChatScreen(
//                                  name: LawyerList[index].data['username'],
//                                  photoUrl: LawyerList[index].data['user_dp'],
//                                  receiverUid:
//                                  LawyerList[index].data['client_uid'])));
//                            },
//                          ),
//                        )),
//
//                  ],
//                ),
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
}
