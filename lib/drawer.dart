import 'package:betterbetter/bzl/googleSignIn.dart';
import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/pages/friends.dart';
import 'package:betterbetter/routes/friends.dart';
import 'package:betterbetter/routes/gameGroups.dart';
import 'package:betterbetter/routes/invitations.dart';
import 'package:betterbetter/routes/login.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final GSignIn gSignIn = GSignIn();

  @override
  Widget build(BuildContext context) {
    var user = gSignIn.currentUser;
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(user.email),
            accountName: Text(user.displayName),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
          ),
          ListTile(
            title: Text(
              "Game groups",
              style: Theme.of(context).textTheme.title,
            ),
            onTap: () => Navigator.push(context, GameGroupsPageRoute()),
            trailing: Icon(Icons.gamepad),
          ),
          ListTile(
            title: Text(
              "Friends",
              style: Theme.of(context).textTheme.title,
            ),
            onTap: () => Navigator.push(context, FriendsPageRoute()),
            trailing: Icon(Icons.people),
          ),
          ListTile(
            title: Text(
              "Invitations",
              style: Theme.of(context).textTheme.title,
            ),
            onTap: () => Navigator.push(context, InvitationsPageRoute()),
            trailing: Icon(Icons.add_box),
          ),
          Container(
            color: Theme.of(context).accentColor,
            margin: EdgeInsets.all(30),
            child: ListTile(
              title: Text(
                "Sign out",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                gSignIn.handleSignOut().then((result) {
                  Navigator.pushAndRemoveUntil(context, LoginPageRoute(),
                      (Route<dynamic> route) => false);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
