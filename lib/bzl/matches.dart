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
    if (matchesIds == null) return {};
    for (int i = matchesIds.length - 1; i >= 0; i--) {
      matches[matchesIds[i]] = await getById(matchesIds[i]);
    }
    return matches;
  }

  computePoints(guess, correct, pointsCorrect, pointsPerfect) {
    if (guess == correct) {
      return pointsCorrect + pointsPerfect;
    } else {
      int homeGuess = int.parse(guess.split(":")[0]);
      int awayGuess = int.parse(guess.split(":")[1]);
      int homeCorrect = int.parse(correct.split(":")[0]);
      int awayCorrect = int.parse(correct.split(":")[1]);

      if ((homeCorrect == awayCorrect && homeGuess == awayGuess) ||
          (homeCorrect - awayCorrect < 0 && homeGuess - awayGuess < 0) ||
          (homeCorrect - awayCorrect > 0 && homeGuess - awayGuess > 0)) {
        return pointsCorrect;
      } else {
        return 0;
      }
    }
  }

  addBet(matchId, userId, bet) async {
    var document = await matchesDB.document(matchId).get();
    var bets = Map<String, String>.from(document.data["bets"]);

    bets[userId] = bet;
    matchesDB.document(matchId).updateData({
      "bets": bets,
    });
  }

  addFinalScore(matchId, groupid, score) async {
    matchesDB.document(matchId).updateData({
      "finalScore": score,
    });
    var groupDocument = await gameGroupsDB.document(groupid).get();
    int pointsCorrect = groupDocument.data["correctGuess"];
    int pointsPerfect = groupDocument.data["perfectGuess"];
    Map<String, int> leaderboard =
        Map<String, int>.from(groupDocument.data["leaderboard"]);

    var matchDocument = await matchesDB.document(matchId).get();
    var bets = Map<String, String>.from(matchDocument.data["bets"]);

    bets.keys.forEach((userid) {
      leaderboard[userid] +=
          computePoints(bets[userid], score, pointsCorrect, pointsPerfect);
    });

    gameGroupsDB.document(groupid).updateData({
      "leaderboard": leaderboard,
    });
  }
}
