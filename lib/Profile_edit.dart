import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:client_lawyer_project/client_login_page.dart';
import 'package:client_lawyer_project/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Profile_Setting extends StatefulWidget {
  @override
  _Profile_SettingState createState() => _Profile_SettingState();
}

class _Profile_SettingState extends State<Profile_Setting> {
  bool isloading = true;
  String dropdownValue = 'Major';
  String mDp = '';
  String mName = '';
  String mType = '';
  String mPhoneNum = '';
  String mLicenceNumber = '';
  String mYearExperience = '';
  String mDescription = '';
  DocumentSnapshot mRef;
  File _image;
  String _uploadedFileURL;
  String url;

  final _namecontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _descriptioncontroller = TextEditingController();
  final databaseReference = Firestore.instance;
  ProgressDialog pr;
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body:isloading ? Container() : ListView(
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
                      child: GestureDetector(
                        onTap: (){
                          uploadPic();
                        },
                        child: CircleAvatar(
                          radius: 50,
                        //  backgroundColor: Colors.white,
                          backgroundImage: mDp == null
                              ? AssetImage('/images/1.jpg')
                              : NetworkImage(mDp),

                        ),
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
                  mType == null ?
                  Text('No Details') : Text(mType
                    ,
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
      isloading = false;
      mName = mRef['username'];
      mType = mRef['about_yourself'];
      mDp = mRef['user_dp'];

      print('mref data $mRef');

    });
  }

  void createRecord() async {
    try {

      pr.style(
          message: 'Updating Profile...',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
      );
      await pr.show();
      String mUid = (await FirebaseAuth.instance.currentUser()).uid;
      //Firestore
      await databaseReference.collection("Users").document(mUid).setData({
        'username': _namecontroller.text,
        'phonenumber': _phonecontroller.text,
        'about_yourself': _descriptioncontroller.text,
      }, merge: true);
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    } catch (e) {
      print(e.message);
    }
  }
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Uri> uploadPic() async {
    pr.style(
        message: 'Uploading Image...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    //Get the file from the image picker and store it
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    String mUid = (await FirebaseAuth.instance.currentUser()).uid;
    await pr.show();
    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child("Profile_user/").child((await FirebaseAuth.instance.currentUser()).uid);

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(_image);
    uploadTask.onComplete.then((result) async {
      pr.update(
        progress: 50.0,
        message: "Please wait...",
        progressWidget: Container(
            padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
      );

      pr.hide().then((isHidden) {
        print(isHidden);
      });
      url = await result.ref.getDownloadURL();

      await databaseReference.collection("Users").document(mUid).updateData({

        'user_dp': url,
      });
      setState(() {

      });
    });

  }
}
