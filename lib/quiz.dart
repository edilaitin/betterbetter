import 'package:betterbetter/answer.dart';
import 'package:betterbetter/question.dart';
import 'package:flutter/material.dart';

class Quiz extends StatelessWidget {
  final Function answerQuestion;
  final int questionIndex;
  final List<Map<String, Object>> questions;

  Quiz(
      {@required this.questions,
      @required this.questionIndex,
      @required this.answerQuestion});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(questions[questionIndex]["questionText"]),
        ...(questions[questionIndex]["answers"] as List<Map<String, Object>>)
            .map((answer) {
          return Answer(answer["text"], () => answerQuestion(answer["score"]));
        }).toList()
      ],
    );
  }
}
