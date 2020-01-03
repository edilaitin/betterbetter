import 'dart:convert';

import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:betterbetter/bzl/user.dart';
import 'package:betterbetter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameGroup {
  String name;
  bool active;
  String creator;
  List<dynamic> players;
  Map<String, int> leaderboard;
  int perfectGuess;
  int correctGuess;
  UserAPI api = UserAPI();
  final GameGroupsDB = Firestore.instance.collection("gameGroups");

  GameGroup({this.name, this.creator}) {
    active = true;
    players = [this.creator];
    leaderboard = {
      this.creator: 0,
    };

    GameGroupsDB.add(this.toMap()).then((document) {
      api.addToGameGroup(creator, document.documentID);
    });
  }

  GameGroup.fromMap(Map<String, dynamic> mapGroup) {
    name = mapGroup['name'];
    active = mapGroup['active'];
    creator = mapGroup['creator'];
    players = mapGroup['players'];
    perfectGuess = mapGroup['perfectGuess'];
    correctGuess = mapGroup['correctGuess'];
    leaderboard = Map<String, int>.from(mapGroup['leaderboard']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'active': active,
      'creator': creator,
      'players': players,
      'leaderboard': leaderboard,
      'perfectGuess': 3,
      'correctGuess': 1,
    };
  }
}
