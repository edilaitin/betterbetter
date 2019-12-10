import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddFriend extends StatefulWidget {
  final Function handler;

  AddFriend(this.handler);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final emailController = TextEditingController();

  bool validEmail(email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void _submitData() {
    final enteredEmail = emailController.text;

    if (enteredEmail.isEmpty || !validEmail(enteredEmail)) {
      return;
    }
    widget.handler(enteredEmail);

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
                  Text("Invite a new friend by it's email"),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      alignLabelWithHint: isLandscape,
                      errorText: emailController.text.isNotEmpty &&
                              !validEmail(emailController.text)
                          ? "Invalid email"
                          : null,
                      labelText: "Email",
                      labelStyle: emailController.text.isEmpty ||
                              !validEmail(emailController.text)
                          ? TextStyle(color: Theme.of(context).errorColor)
                          : null,
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                    controller: emailController,
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
                            child: Text("Invite"),
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
