import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/models/user.dart';
import 'package:flutter/material.dart';

class GameGroupsList extends StatelessWidget {
  final List<GameGroup> gameGroups;

  GameGroupsList({this.gameGroups});

  @override
  Widget build(BuildContext context) {
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
                    gameGroups[index].name,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              );
            },
            itemCount: gameGroups.length,
          );
  }
}
