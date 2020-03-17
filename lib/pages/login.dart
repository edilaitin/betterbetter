import 'package:betterbetter/bzl/googleSignIn.dart';
import 'package:betterbetter/routes/friends.dart';
import 'package:betterbetter/routes/gameGroup.dart';
import 'package:betterbetter/routes/gameGroups.dart';
import 'package:betterbetter/routes/invitations.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GSignIn gSignIn = GSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/better.png"),
              fit: BoxFit.fitWidth,
            ),
            color: Colors.black),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'Quicksand',
                  color: Color(0xffF0002F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.045,
              ),
              OutlineButton(
                highlightedBorderColor: Colors.white,
                splashColor: Color(0xffF0002F),
                onPressed: () async {
                  await gSignIn.handleSignIn();
                  if (gSignIn.currentUser != null)
                    Navigator.push(context, GameGroupsPageRoute());
                  else
                    return;
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                          image: AssetImage("assets/images/google_logo.png"),
                          height: 40.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.045,
              ),
              Text(
                "The joy of placing bets",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  color: Color(0xffF0002F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Text(
                "without spending \$",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  color: Color(0xffF0002F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
