import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int totalScore;
  final Function resetHandler;

  Result(this.totalScore, this.resetHandler);

  String get resultPhrase {
    var resultText = "You did it!";
    if (totalScore <= 8) {
      resultText = "You are awesome";
    } else if (totalScore <= 12) {
      resultText = "Ok dude";
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Text(
            resultPhrase,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: resetHandler,
            child: Text("Reset Quiz"),
          ),
        )
      ],
    );
  }
}
