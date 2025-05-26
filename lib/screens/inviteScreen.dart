import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubhouse/models/userModel.dart';
import 'package:flutter/material.dart';
import '../models/userModel.dart';

class InviteScreen extends StatefulWidget {
  final UserModel? user;
  InviteScreen({this.user});
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final TextEditingController inviteController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  @override
  void dispose() {
    inviteController.clear();
    inviteController.dispose();
    super.dispose();
  }

  Future inviteFriend() async{
    if(inviteController.text.trim().length > 8){
      setState(() {
        isLoading = true;
      });

      _firestore.collection("invites").add({
        "invitee": inviteController.text,
        "invitedBy": widget.user?.phone,
        "date":DateTime.now(),
      }).then((value){
        var invitesOk = widget.user?.invitesLeft;
        int invitesLeftOut =  invitesOk! - 1;
        _firestore.collection("users").doc(widget.user?.uid).update({
          "invitesLeft": invitesLeftOut,
        }).then((value){
          setState(() {
            widget.user?.invitesLeft = invitesLeftOut;
            isLoading = false;
            inviteController.text = "";
          });
        });
      });

    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invite Your Friend"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                "${widget.user?.invitesLeft}",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Center(
              child: Text(
                "Invites Left",
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                controller: inviteController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Friend's Phone number with Country code",
                  hintText: "(eg: +911234*****)",
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            isLoading ? CircularProgressIndicator(): Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                child: Text("Invite Now",style: TextStyle(color: Colors.white,fontSize: 25),),
                onPressed: (){
                  inviteFriend();
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}
