import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  String homeTeam;
  String awayTeam;
  Map<String, String> bets;
  bool concluded;
  Timestamp date;
  String finalScore;
  String group;
  GameGroupsAPI api = GameGroupsAPI();
  final MatchesDB = Firestore.instance.collection("matches");

  Match({this.group, this.homeTeam, this.awayTeam, this.date}) {
    concluded = false;
    finalScore = "";
    bets = {};

    MatchesDB.add(this.toMap()).then((document) {
      api.addMatchToGroup(group, document.documentID);
    });
  }

  Match.fromMap(Map<String, dynamic> mapMatch) {
    homeTeam = mapMatch['homeTeam'];
    awayTeam = mapMatch['awayTeam'];
    concluded = mapMatch['concluded'];
    date = mapMatch['date'] as Timestamp;
    finalScore = mapMatch['finalScore'];
    group = mapMatch['group'];
    bets = Map<String, String>.from(mapMatch['bets']);
  }

  Map<String, dynamic> toMap() {
    return {
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'bets': bets,
      'concluded': concluded,
      'date': date,
      'finalScore': finalScore,
      'group': group,
    };
  }
}
