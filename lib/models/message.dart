

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  //Variables to set a map in Firestore cloud
  String senderUid;
  String receiverUid;
  String type;
  String message;
  FieldValue timestamp;
  String photoUrl;

  //Constructor For Text Messages
  Message({this.senderUid, this.receiverUid, this.type, this.message, this.timestamp});

  //Constructor for Other Type OF messages such as picture
  Message.withoutMessage({this.receiverUid, this.senderUid, this.type, this.timestamp, this.photoUrl});

  //Setting Up map to receiver
  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderUid'] = this.senderUid;
    map['receiverUid'] = this.receiverUid;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  //Setting up map for sender
  Message fromMap(Map<String, dynamic> map) {
    Message _message = Message();
    _message.senderUid = map['senderUid'];
    _message.receiverUid = map['receiverUid'];
    _message.type = map['type'];
    _message.message = map['message'];
    _message.timestamp = map['timestamp'];
    return _message;
  }

  

}