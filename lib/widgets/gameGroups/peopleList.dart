import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:betterbetter/models/user.dart';
import 'package:flutter/material.dart';

class PeopleList extends StatefulWidget {
  final List<User> people;
  final String groupid;

  PeopleList({this.people, this.groupid});

  @override
  _PeopleListState createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  final GameGroupsAPI gameGroupsAPI = GameGroupsAPI();

  inviteFriend(index) {
    gameGroupsAPI.inviteToGroup(widget.groupid, widget.people[index].id);
    final snackBar = SnackBar(
      content: Text(
        'You just invited ' + widget.people[index].name + '!',
        textAlign: TextAlign.center,
      ),
    );

    setState(() {
      widget.people.removeAt(index);
    });

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return widget.people.isEmpty
        ? Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "All your friends are either in this group or invited :)",
                  style: Theme.of(context).textTheme.title,
                ),
              ],
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.people[index].photoUrl),
                    ),
                    title: Text(
                      widget.people[index].name,
                    ),
                    subtitle: Text(
                      widget.people[index].email,
                    ),
                    trailing: RaisedButton(
                      child: Text(
                        "Invite",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => inviteFriend(index),
                      color: Theme.of(context).primaryColor,
                    )),
              );
            },
            itemCount: widget.people.length,
          );
  }
}
