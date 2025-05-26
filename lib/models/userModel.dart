import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  
  UserModel({this.name,this.invitesLeft,this.phone,this.uid,this.invitesAllowed});

  String? name;
  String? uid;
  String? phone;
  int? invitesLeft;
  int? invitesAllowed;
  
  factory UserModel.fromMap(QueryDocumentSnapshot documentSnapshot){
    return UserModel(
      name: documentSnapshot["name"],
      uid: documentSnapshot["uid"],
      invitesLeft: documentSnapshot["invitesLeft"],
      phone: documentSnapshot["phone"],
      invitesAllowed: documentSnapshot["invitesAllowed"],
    );
  }
  Map<String, dynamic> toMap(UserModel user) => {
    'name':user.name,
    'uid':user.uid,
    'phone':user.phone,
    'invitesLeft': user.invitesLeft,
    'invitesAllowed': user.invitesAllowed,
  };


}