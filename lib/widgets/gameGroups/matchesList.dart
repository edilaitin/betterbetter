import 'package:betterbetter/bzl/matches.dart';
import 'package:betterbetter/widgets/gameGroups/matchTile.dart';
import 'package:flutter/material.dart';
import '../../models/match.dart' as match;

class MatchesList extends StatefulWidget {
  final String groupid;
  final String userId;
  final bool isCreator;

  MatchesList({this.groupid, this.userId, this.isCreator});

  @override
  _MatchesListState createState() => _MatchesListState();
}

class _MatchesListState extends State<MatchesList> {
  Map<String, match.Match> matches = {};
  List<match.Match> matchesList = [];
  List<String> matchesIds = [];
  bool loaded = false;
  final api = MatchesAPI();

  @override
  void initState() {
    api.getMatches(widget.groupid).then((result) {
      matches = result;
      matchesList = matches.values.toList();
      matchesIds = matches.keys.toList();
      loaded = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return MatchTile(
          userId: widget.userId,
          groupid: widget.groupid,
          matchId: matchesIds[index],
          awayTeam: matchesList[index].awayTeam,
          homeTeam: matchesList[index].homeTeam,
          correctScore: matchesList[index].finalScore,
          date: matchesList[index].date,
          guessedScore: matchesList[index].bets[widget.userId],
          isCreator: widget.isCreator,
        );
      },
      itemCount: matchesList.length,
    );
  }
}
