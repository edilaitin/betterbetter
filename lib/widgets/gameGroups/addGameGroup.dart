import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddGameGroup extends StatefulWidget {
  final Function handler;

  AddGameGroup(this.handler);

  @override
  _AddGameGroupState createState() => _AddGameGroupState();
}

class _AddGameGroupState extends State<AddGameGroup> {
  final nameController = TextEditingController();

  void _submitData() {
    final enteredName = nameController.text;

    if (enteredName.isEmpty) {
      return;
    }
    widget.handler(enteredName);

    Navigator.of(context).pop();
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
                  Text("Create a new game group"),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      alignLabelWithHint: isLandscape,
                      labelText: "Name",
                      labelStyle: nameController.text.isEmpty
                          ? TextStyle(color: Theme.of(context).errorColor)
                          : null,
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                    controller: nameController,
                    onSubmitted: (_) => _submitData(),
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
