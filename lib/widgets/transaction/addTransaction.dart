import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  final Function handler;

  AddTransaction(this.handler);

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (amountController.text.isEmpty) return;

    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    final enteredData = _selectedDate;

    if (enteredTitle.isEmpty || enteredAmount <= 0 || enteredData == null) {
      return;
    }
    widget.handler(enteredTitle, enteredAmount, enteredData);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
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
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: titleController.text.isEmpty
                          ? TextStyle(color: Theme.of(context).errorColor)
                          : null,
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                    controller: titleController,
                    onSubmitted: (_) => _submitData(),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Amount",
                      labelStyle: amountController.text.isEmpty
                          ? TextStyle(color: Theme.of(context).errorColor)
                          : null,
                    ),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      setState(() {});
                    },
                    onSubmitted: (_) => _submitData(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.3,
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
                        minWidth: MediaQuery.of(context).size.width * 0.3,
                        height: 45,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Text("Add transaction"),
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).textTheme.button.color,
                          onPressed: _submitData,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      );
    });
  }
}
