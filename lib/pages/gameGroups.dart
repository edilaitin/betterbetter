import 'dart:io';

import 'package:betterbetter/bzl/friends.dart';
import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:betterbetter/bzl/googleSignIn.dart';
import 'package:betterbetter/bzl/user.dart';
import 'package:betterbetter/drawer.dart';
import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/models/user.dart';
import 'package:betterbetter/routes/friends.dart';
import 'package:betterbetter/routes/gameGroups.dart';
import 'package:betterbetter/widgets/friends/addFriend.dart';
import 'package:betterbetter/widgets/friends/friendsList.dart';
import 'package:betterbetter/widgets/gameGroups/addGameGroup.dart';
import 'package:betterbetter/widgets/gameGroups/gameGroupsList.dart';
import 'package:flutter/material.dart';

class GameGroupsPage extends StatefulWidget {
  @override
  _GameGroupsPageState createState() => _GameGroupsPageState();
}

class _GameGroupsPageState extends State<GameGroupsPage> {
  GSignIn gSignIn = GSignIn();
  final api = UserAPI();
  Map<String, GameGroup> gameGroups;

  @override
  void initState() {
    api.getGameGroups(gSignIn.currentUser.id).then((result) {
      setState(() {
        gameGroups = result;
      });
    });
  }

  Future<void> addNewGameGroup(String name) async {
    var gameGroup = GameGroup(creator: gSignIn.currentUser.id, name: name);

    await Future.delayed(Duration(seconds: 1));
    api.getGameGroups(gSignIn.currentUser.id).then((result) {
      setState(() {
        gameGroups = result;
      });
    });
  }

  void startAddNewGameGroup(BuildContext ctx) {
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (builderContext) {
          return AddGameGroup(addNewGameGroup);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4.0,
        title: Text("Game groups"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, GameGroupsPageRoute());
            },
          )
        ],
      ),
      body: gameGroups != null
          ? Container(
              child: Column(
                children: <Widget>[
                  GameGroupsList(
                    gameGroups: gameGroups,
                  )
                ],
              ),
            )
          : Text(""),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
        onPressed: () => startAddNewGameGroup(context),
      ),
    );
  }
}
