import 'package:client_lawyer_project/constant.dart';
import 'package:client_lawyer_project/homepage.dart';
import 'package:client_lawyer_project/search_lawyer_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


//In this class User Will Describe Offer to the lawyer
class Describe_Offer extends StatefulWidget {

  //Retreive Data Of Lawyer From Previous Class
  Map _map;
  //Constructor
  Describe_Offer(Map map){
    this._map = map;
    print('my data is $_map');
    _map['user_id'];
  }

  @override
  _Describe_OfferState createState() => _Describe_OfferState(_map);
}

class _Describe_OfferState extends State<Describe_Offer> {

  //Constructor for state
Map _map;
_Describe_OfferState(this._map);
bool _validate = false;

//Variables
  bool isChecked = true;
String lawyer_id= '';
String myname = '';
String lawyer_name ='';
DocumentSnapshot mRef;

//Init function will be called on Start to get Details of users
@override
  void initState() {
    // TODO: implement initState
    getInfo();
    super.initState();
  }
  //Refrence for Firebase
  final databaseReference = Firestore.instance;

//Edit Text Controller
  final _descontroller = TextEditingController();
  final _conscontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //  fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Constant.appColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(child: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Lawyer_Page()));
                            });
                          },),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Center(
                          child: Text('Client Requests',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                            controller : _conscontroller,
                            decoration: InputDecoration(
                              hintText: 'Consultant',
                              errorText: _validate ? 'Value Can\'t Be Empty' : null,
                          ),)
                      ),
                    ],
                  ),
                ),
                Container(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0) ,
                    child: Text("Description",style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400
                    ))),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  child: TextField(

                    maxLength: 100,
                    controller: _descontroller,
                    decoration: InputDecoration(
                      hintText: 'Please Provide Your Decription',
                      errorText: _validate ? 'Value Can\'t Be Empty' : null,

                  ),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Colors.grey.shade600
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                        onPressed: (){
                          setState(() {
                            _conscontroller.text.isEmpty ? _validate = true : _validate = false;
                            _descontroller.text.isEmpty ? _validate = true : _validate = false;
                          });

                         _validate==false?sendOfferReq(): Fluttertoast.showToast(
                             msg: "Please Check Fields",
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.CENTER,
                             timeInSecForIos: 1,
                             backgroundColor: Colors.grey.shade300,
                             textColor: Colors.black,
                             fontSize: 16.0
                         );
                        },
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Function will be called On Request Send
  void sendOfferReq() async{
    try{
      DocumentReference ref = await databaseReference.collection("My Request")
          .add({
        'lawyer_uid': _map['user_uid'],
        'client_uid': (await FirebaseAuth.instance.currentUser()).uid,
        'username': mRef['username'],
        'user_dp': mRef['user_dp'],
        'consultant' : _conscontroller.text,
        'description': _descontroller.text,
        'lawyer_name': _map['username'],
        'lawyer_dp':_map['user_dp'],
        'chat_status': isChecked

      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ClientHomePage()));
      Fluttertoast.showToast(
          msg: "Request Send To Lawyer",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
          fontSize: 16.0
      );
    }catch(e){
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
  //Getting Users Details
void getInfo() async {
   mRef = await Firestore.instance
      .collection("Users")
      .document((await FirebaseAuth.instance.currentUser()).uid)
      .get();
   setState(() {
   });
}

}


