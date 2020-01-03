import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddMatch extends StatefulWidget {
  final Function handler;

  AddMatch(this.handler);

  @override
  _AddMatchState createState() => _AddMatchState();
}

class _AddMatchState extends State<AddMatch> {
  final homeController = TextEditingController();
  final awayController = TextEditingController();
  DateTime _selectedDate;
  TimeOfDay _selectedTime;

  void _submitData() {
    final enteredHomeTeam = homeController.text;
    final enteredAwayTeam = awayController.text;

    if (enteredHomeTeam.isEmpty ||
        enteredAwayTeam.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      return;
    }

    DateTime selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);

    Timestamp timestamp = Timestamp.fromDate(selectedDate);

    widget.handler(
      enteredHomeTeam,
      enteredAwayTeam,
      timestamp,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _presentTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedTime = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return LayoutBuilder(builder: (ctx, constraints) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 10,
            top: !isLandscape ? constraints.maxHeight * 0.3 : 0,
          ),
          child: AlertDialog(
            elevation: 50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add a new match for players to bet on"),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      alignLabelWithHint: isLandscape,
                      labelText: "Home Team",
                      labelStyle: homeController.text.isEmpty
                          ? TextStyle(color: Theme.of(context).errorColor)
                          : null,
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                    controller: homeController,
                    onSubmitted: (_) => {},
                  ),
                  TextField(
                    decoration: InputDecoration(
                      alignLabelWithHint: isLandscape,
                      labelText: "Away Team",
                      labelStyle: awayController.text.isEmpty
                          ? TextStyle(color: Theme.of(context).errorColor)
                          : null,
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                    controller: awayController,
                    onSubmitted: (_) => {},
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? "No date chosen"
                                : DateFormat.yMMMd().format(_selectedDate),
                            style: TextStyle(
                              color: _selectedDate == null
                                  ? Theme.of(context).errorColor
                                  : null,
                            ),
                          ),
                        ),
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            _selectedDate == null
                                ? "Choose date"
                                : "Choose another date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: _presentDatePicker,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _selectedTime == null
                                ? "No time chosen"
                                : DateFormat("HH:mm").format(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    _selectedTime.hour,
                                    _selectedTime.minute)),
                            style: TextStyle(
                              color: _selectedTime == null
                                  ? Theme.of(context).errorColor
                                  : null,
                            ),
                          ),
                        ),
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            _selectedTime == null
                                ? "Choose time"
                                : "Choose another time",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: _presentTimePicker,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.25,
                          height: 45,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Text("Cancel"),
                            color: Theme.of(context).errorColor,
                            textColor: Theme.of(context).textTheme.button.color,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.25,
                          height: 45,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Text("Create"),
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).textTheme.button.color,
                            onPressed: _submitData,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      );
    });
  }
}
