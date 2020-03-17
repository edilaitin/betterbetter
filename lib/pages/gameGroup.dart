import 'package:betterbetter/bzl/friends.dart';
import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:betterbetter/bzl/googleSignIn.dart';
import 'package:betterbetter/bzl/user.dart';
import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/models/user.dart';
import 'package:betterbetter/routes/gameGroup.dart';
import 'package:betterbetter/widgets/gameGroups/addMatch.dart';
import 'package:betterbetter/widgets/gameGroups/leaderboard.dart';
import 'package:betterbetter/widgets/gameGroups/matchTile.dart';
import 'package:betterbetter/widgets/gameGroups/matchesList.dart';
import 'package:betterbetter/widgets/gameGroups/peopleList.dart';
import 'package:betterbetter/widgets/gameGroups/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/match.dart';

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
  bool finishedLoading = false;
  GameGroup gameGroup;
  List<User> invitePlayers = [];
  GSignIn gSignIn = GSignIn();
  Map<String, Match> matches;

  _GameGroupPageState(groupid) {
    this.groupid = groupid;
  }

  @override
  void initState() {
    api.getById(groupid).then((result) {
      gameGroup = result;
      setState(() {});
      friendsApi.getFriends(gSignIn.currentUser.id).then((friends) {
        friends.forEach((friend) {
          bool friendIsInGroup = false;
          gameGroup.players.forEach((playerId) {
            if (friend.id == playerId) friendIsInGroup = true;
          });
          if (!friendIsInGroup) invitePlayers.add(friend);
        });
        api.getMatches(groupid).then((result) {
          matches = result;
          finishedLoading = true;
          setState(() {});
        });
      });
    });
  }

  int _selectedIndex = 0;

  Widget getWidget(int index) {
    switch (index) {
      case 0:
        return finishedLoading == true
            ? Column(
                children: <Widget>[
                  Expanded(
                    child: MatchesList(
                      isCreator: gSignIn.currentUser.id == gameGroup.creator,
                      groupid: groupid,
                      userId: gSignIn.currentUser.id,
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator();
      case 1:
        return Column(
          children: <Widget>[
            Expanded(
              child: Leaderboard(
                groupid: groupid,
              ),
            ),
          ],
        );
      case 2:
        return Column(
          children: <Widget>[
            Expanded(
              child: PeopleList(
                people: invitePlayers,
                groupid: groupid,
              ),
            ),
          ],
        );
      case 3:
        return GroupSettings(
          groupid: groupid,
          perfectGuess: gameGroup.perfectGuess,
          correctGuess: gameGroup.correctGuess,
        );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void addMatch(String homeTeam, String awayTeam, Timestamp timestamp) async {
    var match = Match(
      group: groupid,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      date: timestamp,
    );
    await Future.delayed(Duration(seconds: 1));

    api.getMatches(groupid).then((result) {
      setState(() {
        matches = result;
      });
    });
  }

  void startAddMatch(BuildContext ctx) {
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (builderContext) {
          return AddMatch(addMatch);
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
            ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: (gameGroup != null &&
              gSignIn.currentUser.id == gameGroup.creator &&
              _selectedIndex == 0)
          ? FloatingActionButton(
              onPressed: () => startAddMatch(context),
              child: Icon(Icons.add),
            )
          : Container(),
    );
  }
}
