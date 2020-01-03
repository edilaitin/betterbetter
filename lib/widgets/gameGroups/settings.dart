import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupSettings extends StatefulWidget {
  final String groupid;
  int perfectGuess;
  int correctGuess;

  GroupSettings({this.groupid, this.perfectGuess, this.correctGuess});

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  final GameGroupsAPI gameGroupsAPI = GameGroupsAPI();
  TextEditingController perfectGuessController;
  TextEditingController correctGuessController;

  isDisabled() {
    if (perfectGuessController.text.isEmpty ||
        correctGuessController.text.isEmpty) return true;

    if (perfectGuessController.text == widget.perfectGuess.toString() &&
        correctGuessController.text == widget.correctGuess.toString())
      return true;

    return false;
  }

  saveEntries() {
    gameGroupsAPI.updateSettings(widget.groupid, correctGuessController.text,
        perfectGuessController.text);

    final snackBar = SnackBar(
      content: Text(
        'Settings were saved',
        textAlign: TextAlign.center,
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
    setState(() {
      widget.perfectGuess = int.parse(perfectGuessController.text);
      widget.correctGuess = int.parse(correctGuessController.text);
    });
  }

  @override
  void initState() {
    perfectGuessController =
        TextEditingController(text: widget.perfectGuess.toString());
    correctGuessController =
        TextEditingController(text: widget.correctGuess.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Center(
                      child: Column(children: [
                    Text(
                      '  The number of points a player receives for guessing the outcome of the match without the exact score :',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 120.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            labelText: "Enter number",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(),
                            )),
                        controller: correctGuessController,
                        validator: (val) {
                          if (val.length == 0) {
                            return "Number cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ])),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Center(
                      child: Column(children: [
                    Text(
                      '  The number of points a player receives for a perfect score guess (in addition to previous points) :',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 120.0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Enter number",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                        ),
                        controller: perfectGuessController,
                        validator: (val) {
                          if (val.length == 0) {
                            return "Number cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ])),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0, bottom: 30),
                width: 200,
                height: 60,
                child: RaisedButton(
                  onPressed: isDisabled() ? null : () => saveEntries(),
                  child: Text(
                    "Save",
                    style: TextStyle(
                      //color: Theme.of(context).primaryColor,
                      fontSize: 25,
                    ),
                  ),
                  disabledColor: Colors.grey,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
