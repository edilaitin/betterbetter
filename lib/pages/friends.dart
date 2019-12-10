import 'package:betterbetter/bzl/friends.dart';
import 'package:betterbetter/bzl/googleSignIn.dart';
import 'package:betterbetter/drawer.dart';
import 'package:betterbetter/models/user.dart';
import 'package:betterbetter/routes/friends.dart';
import 'package:betterbetter/widgets/friends/addFriend.dart';
import 'package:betterbetter/widgets/friends/friendsList.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  GSignIn gSignIn = GSignIn();
  final api = FriendsAPI();
  List<User> friends;

  @override
  void initState() {
    api.getFriends(gSignIn.currentUser.id).then((result) {
      setState(() {
        friends = result;
      });
    });
  }

  void _inviteFriend(String invitedUserEmail) {
    api.inviteFriend(gSignIn.currentUser.id, invitedUserEmail);
  }

  Future<void> deleteFriend(userId, friendId) async {
    api.removeFriend(userId, friendId).then((result) {
      setState(() {
        friends = result;
      });
      api.removeFriend(friendId, userId);
    });
  }

  void _startInviteNewFriend(BuildContext ctx) {
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (builderContext) {
          return AddFriend(_inviteFriend);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4.0,
        title: Text("Friends"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, FriendsPageRoute());
            },
          )
        ],
      ),
      body: friends != null
          ? Container(
              child: Column(
                children: <Widget>[
                  FriendsList(
                    currentUserId: gSignIn.currentUser.id,
                    friends: friends,
                    deleteHandler: deleteFriend,
                  )
                ],
              ),
            )
          : Text(""),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
        onPressed: () => _startInviteNewFriend(context),
      ),
    );
  }
}
