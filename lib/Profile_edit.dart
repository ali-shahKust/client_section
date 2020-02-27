import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client_lawyer_project/client_login_page.dart';
import 'package:client_lawyer_project/constant.dart';

class Profile_Setting extends StatefulWidget {
  @override
  _Profile_SettingState createState() => _Profile_SettingState();
}

class _Profile_SettingState extends State<Profile_Setting> {
  String mName = '';
  String mType = '';
  String mPhoneNum = '';
  String mLicenceNumber = '';
  String mYearExperience = '';
  String mDescription = '';

  final _namecontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _descriptioncontroller = TextEditingController();
  final databaseReference = Firestore.instance;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 250,
                color: Constant.appColor,
              ),
              Center(
                child: Column(children: <Widget>[
                  Container(
                      height: 90,
                      margin: EdgeInsets.only(top: 60),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        //   child: Image.asset(),
                      )),
                  Padding(
                    padding: EdgeInsets.all(4),
                  ),
                  Text(
                    mName,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                  ),
                  Text(
                    mType,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ]),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(
                controller: _namecontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Name",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.email,
                        color: Constant.appColor,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(
                controller: _phonecontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Phone Number",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.phone,
                        color: Constant.appColor,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(
                controller: _descriptioncontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: "About Yourself",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.description,
                        color: Constant.appColor,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Constant.appColor),
                child: FlatButton(
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    createRecord();
                  },
                ),
              )),
        ],
      ),
    );
  }

  void getData() async {
    DocumentSnapshot mRef = await Firestore.instance
        .collection("Users")
        .document((await FirebaseAuth.instance.currentUser()).uid)
        .get();
    setState(() {
      mName = mRef['username'];
      mType = mRef['about_yourself'];
    });
  }

  void createRecord() async {
    try {
      String mUid = (await FirebaseAuth.instance.currentUser()).uid;
      //Firestore
      await databaseReference.collection("Users").document(mUid).setData({
        'username': _namecontroller.text,
        'phonenumber': _phonecontroller.text,
        'about_yourself': _descriptioncontroller.text,
      }, merge: true);
    } catch (e) {
      print(e.message);
    }
  }
}
