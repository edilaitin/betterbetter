import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:betterbetter/bzl/user.dart';
import 'package:betterbetter/models/user.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  Map<dynamic, dynamic> scores = {};
  final String groupid;

  Leaderboard({this.groupid});

  @override
  _LeaderboardState createState() => _LeaderboardState(scores: this.scores);
}

class _LeaderboardState extends State<Leaderboard> {
  List<User> players = [];
  List<int> points;
  Map<dynamic, dynamic> scores;
  final UserAPI userAPI = new UserAPI();
  final api = GameGroupsAPI();

  _LeaderboardState({this.scores});
  final GameGroupsAPI gameGroupsAPI = GameGroupsAPI();

  @override
  void initState() {
    api.getLeaderboard(widget.groupid).then((leaderboard) {
      scores = leaderboard;
      points = List<int>.from(scores.values.toList());
      List<String> usersIds = List<String>.from(scores.keys.toList());
      usersIds.forEach((userid) {
        userAPI.getById(userid).then((user) {
          players.add(user);
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return players.isEmpty
        ? Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                /*Text(
                  "There is no one in this group :)",
                  style: Theme.of(context).textTheme.title,
                ),*/
              ],
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(players[index].photoUrl),
                    ),
                    title: Text(
                      players[index].name,
                    ),
                    subtitle: Text(
                      players[index].email,
                    ),
                    trailing: Text(
                      points[index].toString() + " points",
                    )),
              );
            },
            itemCount: players.length,
          );
  }
}
