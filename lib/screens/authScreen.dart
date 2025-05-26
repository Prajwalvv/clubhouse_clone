import 'package:clubhouse/models/userModel.dart';
import 'package:clubhouse/screens/homeScreen.dart';
import 'package:clubhouse/screens/notInvitedScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/userModel.dart';
import './notInvitedScreen.dart';

class AuthScreen extends StatefulWidget {
  
  @override
  _AuthScreenState createState() => _AuthScreenState();

  void onSignedIn() {}
}

class _AuthScreenState extends State<AuthScreen> {
  _AuthScreenState({this.onSignedIn});

  final VoidCallback? onSignedIn;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool isloadin = false;
  bool isotpScreen = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var verificationCode;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future phoneAuth() async {
    var _phoneNumber = phoneController.text.trim();
    setState(() {
      isloadin = true;
    });

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          _firebaseAuth.signInWithCredential(credential).then((userData) async {
            if (userData != null) {
              await _firestore.collection("users").doc(userData.user?.uid).set({
                "name": "",
                "phone": userData.user?.phoneNumber,
                "uid": userData.user?.uid,
                "invitesLeft": 5,
                "invitesAllowed": 5,
              });
              setState(() {
                isloadin = false;
              });
              //navigate to home screen in future
            }
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          print("firebase error : ${error.message}");
        },
        codeSent: (String verificationId, int) {
          setState(() {
            isloadin = false;
            isotpScreen = true;
            verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isloadin = false;
            verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 120));
  }

  Future otpSignIn() async {
    setState(() {
      isloadin = true;
    });
    try {
      _firebaseAuth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationCode,
              smsCode: otpController.text.trim()))
          .then((userData) async {
        UserModel user;
        if (userData != null) {
          var userExist = await _firestore
              .collection("users")
              .where("phone", isEqualTo: phoneController.text)
              .get();

          if (userExist.docs.length > 0) {
            print("USER IS ALREADY THERE");
            user = UserModel();
          } else {
            print("New User Created");
            user = UserModel(
              name: "",
              phone: userData.user?.phoneNumber,
              invitesLeft: 5,
              uid: userData.user?.uid,
              invitesAllowed: 5,
            );
            //this i have changed to user form user model
            await _firestore
                .collection("users")
                .doc(userData.user?.uid)
                .set(UserModel().toMap(user));
          }
          var userInvited = await _firestore.collection("invites").where("invitee", isEqualTo: phoneController.text).get();
          if(userInvited.docs.length < 1){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NotInvitedScreen()));
            return;
          }
          setState(() {
            isloadin = false;
          });
          print("Login Successful");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        user: user,
                      )));
          //
          
        }
      });
      widget.onSignedIn();
    } catch (e) {
      print(e.toString());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.black,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 60),
              height: 150,
              child: Text(
                "Club House",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Icon(
                        Icons.connect_without_contact,
                        size: 60,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Login with Phone",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.00,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      //if otp is asked it will show the otp Textfield.
                      isotpScreen
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: TextField(
                                controller: otpController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter OTP",
                                    hintText: "Enter the OTP you got"),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter Phone Number with country code",
                                    hintText:
                                        "Enter your invited phone number"),
                              ),
                            ),
                      SizedBox(
                        height: 30,
                      ),
                      isloadin
                          ? CircularProgressIndicator()
                          : Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  isotpScreen ? otpSignIn() : phoneAuth();
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
