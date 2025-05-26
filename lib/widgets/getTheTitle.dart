import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetTheTitle{
  GetTheTitle({this.titleName});
  String? titleName;

factory GetTheTitle.fromMap(DocumentSnapshot documentSnapshot){
    return GetTheTitle(
      titleName: documentSnapshot["categories"],
    );
  }
Map<String, dynamic> toMap(GetTheTitle categories) => {
    'title1':categories.titleName,
  };

  // Future FetchCategories() async {
  //   DocumentSnapshot variable = await FirebaseFirestore.instance.collection("categories").doc("GbUxfI8OPULV0iOEYg7K").get();
  //   variable["title1"];
  // }
  
  }


