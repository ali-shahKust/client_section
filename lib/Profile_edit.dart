import 'dart:io';

import 'package:client_lawyer_project/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client_lawyer_project/client_login_page.dart';
import 'package:client_lawyer_project/constant.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'accepted_request.dart';


class Profile_Setting extends StatefulWidget {
  @override
  _Profile_SettingState createState() => _Profile_SettingState();
}

class _Profile_SettingState extends State<Profile_Setting> {
  final primary = Constant.appColor;
  final secondary = Constant.appColor;
  String myName = '';
  String abtMe = '';
  String myDp = '';
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
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
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

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color active = Colors.white;
  final Color divider = Colors.white;
  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context);
    if(mRef != null){
      _namecontroller.text = mRef['username'];
      _phonecontroller.text = mRef['phonenumber'];
      _descriptioncontroller.text = mRef['about_yourself'];
    }
    return Scaffold(
      backgroundColor: Colors.white,
        key: _key,
        drawer:_buildDrawer(),
      body:isloading ? Container() : SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),

        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
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
      ),
    );
  }

  void getData() async {
     mRef = await Firestore.instance
        .collection("Users")
        .document((await FirebaseAuth.instance.currentUser()).uid)
        .get();
    setState(() {
      isloading = false;

      myName = mRef['username'];
      abtMe = mRef['about_yourself'];
      myDp = mRef['user_dp'];
      mName = mRef['username'];
      mType = mRef['about_yourself'];
      mPhoneNum = mRef['phonenumber'];
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
      Fluttertoast.showToast(
          msg: "Profile Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          fontSize: 16.0
      );
      pr.hide().then((isHidden) {
        print(isHidden);
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientHomePage()));
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          fontSize: 16.0
      );
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

      Fluttertoast.showToast(
          msg: 'Picture Uploaded Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          fontSize: 16.0
      );
      await databaseReference.collection("Users").document(mUid).updateData({

        'user_dp': url,
      });
      setState(() {

      });
    });

  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  //Side Navigation
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
