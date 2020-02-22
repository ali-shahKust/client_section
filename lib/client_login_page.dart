import 'package:client_lawyer_project/search_lawyer_page.dart';
import 'package:flutter/material.dart';
import 'package:client_lawyer_project/constant.dart';
import 'package:client_lawyer_project/client_signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Client_Login extends StatefulWidget {
  @override
  _Client_LoginState createState() => _Client_LoginState();
}

class _Client_LoginState extends State<Client_Login> {
  //Variables For Email and password and formkey


  final FirebaseAuth _auth = FirebaseAuth.instance;
 String _email, _password;
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Icon(
                      Icons.account_balance,
                      color: Constant.appColor,
                      size: 60,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Lawyer",
                      style: TextStyle(
                          color: Constant.appColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 30),
                    ),
                  ],
                ),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    gradient:
                    LinearGradient(colors: [Colors.white, Colors.white])),
              ),
            ],
          ),
          SizedBox(
            height: 0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(
                onChanged: (String value) {

                },
                controller: _emailcontroller,
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Email",
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

                controller: _passwordcontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
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
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Constant.appColor),
                child: FlatButton(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: signIn,
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "FORGET PASSWORD ?",
              style: TextStyle(
                  color: Constant.appColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Don't have an Account ? ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
              GestureDetector(
                child: Text("Sign Up ",
                    style: TextStyle(
                        color: Constant.appColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        decoration: TextDecoration.underline)),
                onTap: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Client_Signup()));
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> signIn() async {

    _email = _emailcontroller.text;
    _password = _passwordcontroller.text;

      try{
         await FirebaseAuth.instance.signInWithEmailAndPassword(email:_email , password: _password);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Lawyer_Page()));
      }catch(e){
        print(e.message);
      }
    }


}