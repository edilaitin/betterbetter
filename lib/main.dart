import 'package:betterbetter/quiz.dart';
import 'package:betterbetter/result.dart';
import 'package:flutter/material.dart';

import './question.dart';
import './answer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int _questionIndex = 0;
  int _totalScore = 0;

  void answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    print("Question answered");
  }

  void resetQuiz() {
    setState(() {
      _totalScore = 0;
      _questionIndex = 0;
    });
    print("Quiz reset");
  }

  @override
  Widget build(BuildContext context) {
    const _questions = [
      {
        "questionText": "What's your favorite color",
        "answers": [
          {"text": "Black", "score": 10},
          {"text": "Red", "score": 7},
          {"text": "Green", "score": 2},
          {"text": "White", "score": 5},
        ]
      },
      {
        "questionText": "What's your favorite animal",
        "answers": [
          {"text": "Cat", "score": 10},
          {"text": "Dog", "score": 7},
          {"text": "Rabbit", "score": 2},
          {"text": "Elephant", "score": 5},
        ]
      },
      {
        "questionText": "What's your favorite football team",
        "answers": [
          {"text": "FC Barcelona", "score": 10},
          {"text": "FC Bayern", "score": 7},
          {"text": "FC Real Madrid", "score": 2},
          {"text": "FCSB", "score": 5},
        ]
      },
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hello boiii, esti pa biit?"),
          centerTitle: true,
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                questions: _questions,
                questionIndex: _questionIndex,
                answerQuestion: answerQuestion)
            : Result(_totalScore, resetQuiz),
      ),
    );
  }
}
