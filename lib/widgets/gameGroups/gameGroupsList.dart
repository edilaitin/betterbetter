import 'package:betterbetter/bzl/googleSignIn.dart';
import 'package:betterbetter/bzl/user.dart';
import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/models/user.dart';
import 'package:betterbetter/routes/gameGroup.dart';
import 'package:flutter/material.dart';

class GameGroupsList extends StatelessWidget {
  final Map<String, GameGroup> gameGroups;
  final UserAPI userAPI = new UserAPI();
  GSignIn gSignIn = GSignIn();

  GameGroupsList({this.gameGroups});

  @override
  Widget build(BuildContext context) {
    List<GameGroup> gameGroupsList = gameGroups.values.toList();
    List<String> gameGroupsIds = gameGroups.keys.toList();

    return gameGroups.isEmpty
        ? Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "You are not part of any group ༼☯﹏☯༽",
                  style: Theme.of(context).textTheme.title,
                ),
              ],
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              int userScore =
                  gameGroupsList[index].leaderboard[gSignIn.currentUser.id];
              List<int> scores =
                  gameGroupsList[index].leaderboard.values.toList();
              scores.sort();
              scores = List<int>.from(scores.reversed);
              return Card(
                color: Theme.of(context).accentColor,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: Text(
                    gameGroupsList[index].name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    "Number of players: " +
                        gameGroupsList[index].players.length.toString(),
                  ),
                  trailing: Text("Your position: " +
                      (scores.indexOf(userScore) + 1).toString()),
                  onTap: () => Navigator.push(
                      context, GameGroupPageRoute(gameGroupsIds[index])),
                ),
              );
            },
            itemCount: gameGroupsList.length,
          );
  }
}
