import 'package:client_lawyer_project/constant.dart';
import 'package:client_lawyer_project/search_lawyer_page.dart';
import 'package:flutter/material.dart';

class Describe_Offer extends StatelessWidget {
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
                  child: Padding(
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
                ),
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: buildDropdownButton(['Type Of Consultant','Blue','Red'],'Type Of Consultant')
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
                  child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dignissim erat in accumsan tempus. Mauris congue luctus neque, in semper purus maximus iaculis. Donec et eleifend quam, a sollicitudin magna.",
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search_Lawyer_Page()));
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

  Widget buildDropdownButton(List<String> items, String selectedValue) {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedValue,
      onChanged: (_) {},
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}