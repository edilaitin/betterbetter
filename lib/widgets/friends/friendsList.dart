import 'package:betterbetter/models/user.dart';
import 'package:flutter/material.dart';

class FriendsList extends StatelessWidget {
  final String currentUserId;
  final List<User> friends;
  final Function deleteHandler;

  FriendsList({this.currentUserId, this.friends, this.deleteHandler});

  @override
  Widget build(BuildContext context) {
    return friends.isEmpty
        ? Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "You have no friends ༼☯﹏☯༽",
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
                    backgroundImage: NetworkImage(friends[index].photoUrl),
                  ),
                  title: Text(
                    friends[index].name,
                  ),
                  subtitle: Text(
                    friends[index].email,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () =>
                        deleteHandler(currentUserId, friends[index].id),
                    color: Theme.of(context).errorColor,
                  ),
                ),
              );
            },
            itemCount: friends.length,
          );
  }
}
