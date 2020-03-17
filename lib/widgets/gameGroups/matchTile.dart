import 'package:betterbetter/bzl/matches.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class MatchTile extends StatefulWidget {
  final String matchId;
  final String userId;
  final String groupid;
  final String homeTeam;
  final String awayTeam;
  final bool isCreator;
  final String guessedScore;
  String correctScore;
  final Timestamp date;

  MatchTile({
    this.matchId,
    this.userId,
    this.groupid,
    this.homeTeam,
    this.awayTeam,
    this.isCreator,
    this.guessedScore,
    this.correctScore,
    this.date,
  });

  @override
  _MatchTileState createState() => _MatchTileState();
}

class _MatchTileState extends State<MatchTile> {
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  final api = MatchesAPI();
  TextEditingController homeController = TextEditingController();
  TextEditingController awayController = TextEditingController();

  TextEditingController finalHomeController = TextEditingController();
  TextEditingController finalAwayController = TextEditingController();

  Color getColor() {
    if (isBettingAllowed() == false &&
        (widget.guessedScore == null || widget.guessedScore.isEmpty)) {
      return Theme.of(context).errorColor;
    } else if (widget.correctScore.isEmpty || widget.correctScore == null) {
      return Color(0xffdadada);
    } else if (widget.guessedScore == widget.correctScore) {
      return Colors.green[700];
    } else {
      int homeGuess = int.parse(widget.guessedScore.split(":")[0]);
      int awayGuess = int.parse(widget.guessedScore.split(":")[1]);
      int homeCorrect = int.parse(widget.correctScore.split(":")[0]);
      int awayCorrect = int.parse(widget.correctScore.split(":")[1]);

      if ((homeCorrect == awayCorrect && homeGuess == awayGuess) ||
          (homeCorrect - awayCorrect < 0 && homeGuess - awayGuess < 0) ||
          (homeCorrect - awayCorrect > 0 && homeGuess - awayGuess > 0)) {
        return Colors.yellow[600];
      } else {
        return Theme.of(context).errorColor;
      }
    }
  }

  isBettingAllowed() {
    DateTime date = widget.date.toDate();
    if (date.isAfter(DateTime.now())) return true;
    return false;
  }

  submitScore() {
    String homeGuess = homeController.text;
    String awayGuess = awayController.text;
    String bet = homeGuess + ':' + awayGuess;

    if (homeGuess.isNotEmpty && awayGuess.isNotEmpty) {
      api.addBet(widget.matchId, widget.userId, bet);
    }

    return;
  }

  submitFinalResult() {
    String homeFinal = finalHomeController.text;
    String awayFinal = finalAwayController.text;
    String finalResult = homeFinal + ':' + awayFinal;

    if (awayFinal.isNotEmpty && homeFinal.isNotEmpty) {
      api.addFinalScore(widget.matchId, widget.groupid, finalResult);
      widget.correctScore = finalResult;
    }
    return;
  }

  @override
  void initState() {
    if (widget.guessedScore != null && widget.guessedScore.isNotEmpty) {
      String homeGuess = widget.guessedScore.split(':')[0];
      String awayGuess = widget.guessedScore.split(':')[1];

      homeController = TextEditingController(text: homeGuess);
      awayController = TextEditingController(text: awayGuess);
    }
    if (widget.correctScore != null && widget.correctScore.isNotEmpty) {
      String homeCorrect = widget.correctScore.split(':')[0];
      String awayCorrect = widget.correctScore.split(':')[1];

      finalHomeController = TextEditingController(text: homeCorrect);
      finalAwayController = TextEditingController(text: awayCorrect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SimpleFoldingCell(
          key: _foldingCellKey,
          frontWidget: _buildFrontWidget(),
          innerTopWidget: _buildInnerTopWidget(),
          innerBottomWidget: _buildInnerBottomWidget(),
          cellSize: Size(MediaQuery.of(context).size.width, 145),
          padding: EdgeInsets.all(15),
          animationDuration: Duration(milliseconds: 300),
          borderRadius: 10,
          onOpen: () => print('cell opened'),
          onClose: () => print('cell closed')),
    );
  }

  Widget _buildFrontWidget() {
    DateTime date = widget.date.toDate();

    return GestureDetector(
      onTap: (widget.isCreator || widget.correctScore.isNotEmpty) &&
              !isBettingAllowed()
          ? () => _foldingCellKey?.currentState?.toggleFold()
          : null,
      child: Container(
          color: getColor(),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                alignment: AlignmentDirectional.centerEnd,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.homeTeam,
                    style: TextStyle(
                        color: Color(0xFF2e282a),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    DateFormat.yMMMMd("en_US").format(date),
                    style: TextStyle(
                        color: Color(0xFF2e282a),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              enabled: isBettingAllowed(),
                              controller: homeController,
                              showCursor: false,
                              cursorWidth: 0,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                              ],
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                              onSubmitted: submitScore(),
                              decoration: new InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              enabled: isBettingAllowed(),
                              onSubmitted: submitScore(),
                              controller: awayController,
                              showCursor: false,
                              cursorWidth: 0,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                              ],
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                              decoration: new InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat.Hm().format(date),
                    style: TextStyle(
                        color: Color(0xFF2e282a),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                alignment: AlignmentDirectional.centerStart,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.awayTeam,
                    style: TextStyle(
                        color: Color(0xFF2e282a),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildInnerTopWidget() {
    DateTime date = widget.date.toDate();

    return Container(
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            alignment: AlignmentDirectional.centerEnd,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.homeTeam,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                DateFormat.yMMMMd("en_US").format(date),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          enabled: widget.correctScore.isEmpty,
                          controller: finalHomeController,
                          showCursor: false,
                          cursorWidth: 0,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                          ],
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                          decoration: new InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          enabled: widget.correctScore.isEmpty,
                          controller: finalAwayController,
                          showCursor: false,
                          cursorWidth: 0,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                          ],
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                          decoration: new InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                DateFormat.Hm().format(date),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            alignment: AlignmentDirectional.centerStart,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.awayTeam,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerBottomWidget() {
    return Container(
      color: Theme.of(context).accentColor,
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            widget.correctScore.isEmpty && widget.isCreator
                ? "Please write the final score"
                : "This is the final score",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => _foldingCellKey?.currentState?.toggleFold(),
                  child: Text(
                    !(widget.correctScore != null ||
                            widget.correctScore.isNotEmpty)
                        ? "Cancel"
                        : "Close",
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).errorColor,
                  splashColor: Colors.white.withOpacity(0.5),
                ),
                if (widget.correctScore.isEmpty)
                  RaisedButton(
                    onPressed: widget.correctScore.isEmpty
                        ? () {
                            _foldingCellKey?.currentState?.toggleFold();
                            submitFinalResult();
                          }
                        : null,
                    child: Text(
                      "Submit score",
                    ),
                    disabledColor: Color(0xffdadada),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    splashColor: Colors.white.withOpacity(0.5),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
