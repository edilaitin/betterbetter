import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:betterbetter/models/user.dart';
import 'package:flutter/material.dart';

class PeopleList extends StatelessWidget {
  final List<User> people;
  final String groupid;
  final GameGroupsAPI gameGroupsAPI = GameGroupsAPI();

  PeopleList({this.people, this.groupid});

  @override
  Widget build(BuildContext context) {
    return people.isEmpty
        ? Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "All your friends are in this group :)",
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
                      backgroundImage: NetworkImage(people[index].photoUrl),
                    ),
                    title: Text(
                      people[index].name,
                    ),
                    subtitle: Text(
                      people[index].email,
                    ),
                    trailing: RaisedButton(
                      child: Text(
                        "Invite",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        gameGroupsAPI.inviteToGroup(groupid, people[index].id);
                        final snackBar = SnackBar(
                          content: Text(
                            'You just invited ' + people[index].name + '!',
                            textAlign: TextAlign.center,
                          ),
                        );

                        // Find the Scaffold in the widget tree and use
                        // it to show a SnackBar.
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      color: Theme.of(context).primaryColor,
                    )),
              );
            },
            itemCount: people.length,
          );
  }
}
