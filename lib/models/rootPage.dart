// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:clubhouse/screens/authScreen.dart';
// import 'package:clubhouse/screens/homeScreen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import '../models/userModel.dart';

// class RootPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _RootPageState();
// }
// enum AuthStatus {
//   notDetermined,
//   notSignedIn,
//   signedIn,
// }
// class _RootPageState extends State<RootPage> {
//   AuthStatus authStatus = AuthStatus.notDetermined;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final BaseAuth auth = AuthProvider.of(context).auth;
//     auth.currentUser().then((String userId) {
//       setState(() {
//         authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
//       });
//     });
//   }

//   void _signedIn() {
//     setState(() {
//       authStatus = AuthStatus.signedIn;
//     });
//   }

//   void _signedOut() {
//     setState(() {
//       authStatus = AuthStatus.notSignedIn;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     switch (authStatus) {
//       case AuthStatus.notDetermined:
//         return _buildWaitingScreen();
//       case AuthStatus.notSignedIn:
//         return (
//           onSignedIn: _signedIn,
//         );
//       case AuthStatus.signedIn:
//         return HomeScreen(
//           onSignedOut: _signedOut,
//         );
//     }
//     return null;
//   }

//   Widget _buildWaitingScreen() {
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }