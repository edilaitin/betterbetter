import 'package:betterbetter/bzl/friends.dart';
import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:betterbetter/bzl/googleSignIn.dart';
import 'package:betterbetter/bzl/user.dart';
import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/models/user.dart';
import 'package:betterbetter/routes/gameGroup.dart';
import 'package:betterbetter/widgets/gameGroups/leaderboard.dart';
import 'package:betterbetter/widgets/gameGroups/peopleList.dart';
import 'package:flutter/material.dart';

import '../drawer.dart';

class GameGroupPage extends StatefulWidget {
  var groupid;

  GameGroupPage(String groupid) {
    this.groupid = groupid;
  }

  @override
  _GameGroupPageState createState() => _GameGroupPageState(groupid);
}

class _GameGroupPageState extends State<GameGroupPage> {
  var groupid;
  final api = GameGroupsAPI();
  final userApi = UserAPI();
  final friendsApi = FriendsAPI();
  GameGroup gameGroup;
  List<User> invitePlayers = [];
  Map<dynamic, dynamic> scores;
  GSignIn gSignIn = GSignIn();

  _GameGroupPageState(groupid) {
    this.groupid = groupid;
  }

  @override
  void initState() {
    api.getById(groupid).then((result) {
      gameGroup = result;
      setState(() {});
      api.getLeaderboard(groupid).then((leaderboard) {
        scores = leaderboard;
        friendsApi.getFriends(gSignIn.currentUser.id).then((friends) {
          friends.forEach((friend) {
            bool friendIsInGroup = false;
            gameGroup.players.forEach((playerId) {
              if (friend.id == playerId) friendIsInGroup = true;
            });
            if (!friendIsInGroup) invitePlayers.add(friend);
          });
          setState(() {});
        });
      });
    });
  }

  int _selectedIndex = 0;

  Widget getWidget(int index) {
    switch (index) {
      case 0:
        return Text(
          'Index 0: Home',
        );
      case 1:
        return Column(
          children: <Widget>[
            Leaderboard(
              scores: scores,
            ),
          ],
        );
      case 2:
        return Column(
          children: <Widget>[
            PeopleList(
              people: invitePlayers,
              groupid: groupid,
            ),
          ],
        );
      case 3:
        return Text(
          'Index 0: Home',
        );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: gameGroup != null
            ? Text(gameGroup.name)
            : Text("Waiting for group information"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, GameGroupPageRoute(groupid));
            },
          )
        ],
      ),
      body: Center(
        child: getWidget(_selectedIndex),
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            title: Text('Leaderboard'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            title: Text('Invite players'),
          ),
          if (gameGroup != null && gSignIn.currentUser.id == gameGroup.creator)
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}