import 'package:client_lawyer_project/client_login_page.dart';
import'package:flutter/material.dart';

import 'search_lawyer_page.dart';

void main()=>runApp(
  MaterialApp(
    home:MyApp() ,
  )
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:Client_Login(),
    );
  }
}
