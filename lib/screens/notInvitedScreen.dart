import 'package:flutter/material.dart';

class NotInvitedScreen extends StatelessWidget {
  const NotInvitedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.redAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_disabled,
                size: 40,
                color: Colors.white,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "You have not been invited yet",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
