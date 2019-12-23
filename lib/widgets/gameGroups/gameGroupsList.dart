import 'package:betterbetter/bzl/user.dart';
import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/models/user.dart';
import 'package:betterbetter/routes/gameGroup.dart';
import 'package:flutter/material.dart';

class GameGroupsList extends StatelessWidget {
  final Map<String, GameGroup> gameGroups;
  final UserAPI userAPI = new UserAPI();

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
              return Card(
                child: ListTile(
                  title: Text(
                    gameGroupsList[index].name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    "Number of players: " +
                        gameGroupsList[index].players.length.toString(),
                  ),
                  onTap: () => Navigator.push(
                      context, GameGroupPageRoute(gameGroupsIds[index])),
                ),
              );
            },
            itemCount: gameGroupsList.length,
          );
  }
}
