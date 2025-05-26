import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubhouse/screens/authScreen.dart';
import 'package:clubhouse/screens/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/userModel.dart';
import '../screens/notInvitedScreen.dart';

void main() async {
  //this is important to Initialise
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Club House',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: AuthecateUser(),
    );
  }
}

class AuthecateUser extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  get data => null;

  get state => null;

  Future checkCurrentUser() async {
    if (_firebaseAuth.currentUser != null) {
      var userInvited = await _firestore.collection("invites").where("invitee", isEqualTo: _firebaseAuth.currentUser?.phoneNumber).get();
          if(userInvited.docs.length < 1){
            return NotInvitedScreen();
          }
      var userExist = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: _firebaseAuth.currentUser?.uid)
          .get();
      UserModel user = UserModel.fromMap(userExist.docs.first);
      return HomeScreen(
        user: user,
      );
    } else {
      return AuthScreen();
    }
  }
  

//                                             old code
//  checkIfUserLoggedin() {
 
//     if (_firebaseAuth.currentUser == null) {
//       return AuthScreen();
//     } else {
//       return HomeScreen();
//     }
//  }

checkIfUserLoggedin() {
   return FutureBuilder(
     future: checkCurrentUser(),
     builder: (BuildContext context, snapshot) {
       if (snapshot.hasData) {
         return HomeScreen();
       } else {
         return AuthScreen();
       }
     },
   );
 }
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkCurrentUser(),
      //this line is Nonsense snapshot does not work i have chcanged it to
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }else{
         return checkIfUserLoggedin();
        }
      },
    );
  }
  
 
 
 

  /// returns the initial screen depending on the authentication results
  // handleAuth() {
  //   return StreamBuilder(
  //     stream: FirebaseAuth.instance.onAuthStateChanged,
  //     builder: (BuildContext context, snapshot) {
  //       if (snapshot.hasData) {
  //         return HomeScreen();
  //       } else {
  //         return PhoneScreen();
  //       }
  //     },
  //   );
  
 
 
  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: checkCurrentUser(),
  //     builder: (context, snapshot){
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Container(
  //           color: Colors.white,
  //           child: Center(
  //             child: CircularProgressIndicator(),
              
  //           ),
  //         );
  //       }else{
  //        return HomeScreen();
  //       }
  //     },
  //   );
  // }
}
