import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/models/user.dart';
import 'package:flutter/material.dart';

class InvitationsList extends StatelessWidget {
  final Map<String, GameGroup> invitations;
  final Function rejectHandler;
  final Function acceptHandler;

  InvitationsList({
    this.invitations,
    this.rejectHandler,
    this.acceptHandler,
  });

  @override
  Widget build(BuildContext context) {
    List<GameGroup> gameGroupsList = invitations.values.toList();
    List<String> gameGroupsIds = invitations.keys.toList();

    return gameGroupsList.isEmpty
        ? Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "You have no invitations",
                style: Theme.of(context).textTheme.title,
              ),
              Container(
                margin: EdgeInsets.all(30),
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset('assets/images/waiting.png'),
              ),
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      gameGroupsList[index].name,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  trailing: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          child: Text("Confirm"),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          onPressed: () => acceptHandler(gameGroupsIds[index]),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.025,
                        ),
                        RaisedButton(
                          child: Text("Decline"),
                          color: Colors.white,
                          onPressed: () => rejectHandler(gameGroupsIds[index]),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: gameGroupsList.length,
          );
  }
}
