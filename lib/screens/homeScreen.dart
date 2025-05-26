import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubhouse/main.dart';
import 'package:clubhouse/models/userModel.dart';
import 'package:clubhouse/screens/createAclub.dart';
import 'package:clubhouse/screens/profileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/userModel.dart';
import 'inviteScreen.dart';
import 'package:clubhouse/widgets/getTheTitle.dart';

class HomeScreen extends StatefulWidget {
  final UserModel? user;

  HomeScreen({this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
void initState() { 
    if(widget.user?.name == null){
     Future.microtask(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProfileScreen(widget.user)))); 
    }
    super.initState();
    
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAClub(user: widget.user,)));
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("invite"),
              onTap: (){
                Navigator.pop(context);
                var user = widget.user;
                Navigator.push(context, MaterialPageRoute(builder: (context) => InviteScreen(user: user)));
              },
            ),
          ],
        ),
      ),
      
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              icon: Icon(Icons.power_settings_new_outlined), onPressed: () async{
                FirebaseAuth.instance.signOut().then((value){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthecateUser()));

                });
              })
        ],
      ),
      body: Container(),
    );
  }
}
