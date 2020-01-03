import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/match.dart';

class MatchesAPI {
  final matchesDB = Firestore.instance.collection("matches");
  final gameGroupsDB = Firestore.instance.collection("gameGroups");

  Future<Match> getById(userid) async {
    var document = await matchesDB.document(userid).get();
    return Match.fromMap(document.data);
  }

  Future<Map<String, Match>> getMatches(groupid) async {
    var document = await gameGroupsDB.document(groupid).get();
    var matchesIds = document.data["matches"];
    Map<String, Match> matches = {};

    for (int i = 0; i < matchesIds.length; i++) {
      matches[matchesIds[i]] = await getById(matchesIds[i]);
    }
    return matches;
  }
}
