import 'package:betterbetter/bzl/friends.dart';
import 'package:betterbetter/bzl/googleSignIn.dart';
import 'package:betterbetter/widgets/friends/invitationsList.dart';
import 'package:flutter/material.dart';

class Invitations extends StatefulWidget {
  final String collection;

  Invitations({this.collection});

  @override
  _InvitationsState createState() => _InvitationsState(collection: collection);
}

class _InvitationsState extends State<Invitations> {
  String collection;
  GSignIn gSignIn = GSignIn();
  final api = FriendsAPI();
  _InvitationsState({this.collection});
  List collectionList;

  @override
  void initState() {
    if (collection == "friends") {
      api.getFriendInvitations(gSignIn.currentUser.id).then((result) {
        setState(() {
          collectionList = result;
        });
      });
    } else if (collection == "groups") {
      api.getGroupInvitations(gSignIn.currentUser.id).then((result) {
        setState(() {
          collectionList = result;
        });
      });
    }
  }

  void acceptInvitation(id) {
    if (collection == "friends") {
      api
          .acceptFriendInvitation(gSignIn.currentUser.id, id)
          .then((invitations) {
        setState(() {
          collectionList = invitations;
        });
      });
    }
  }

  void rejectInvitation(collection, id) {
    api
        .rejectFriendInvitation(collection, gSignIn.currentUser.id, id)
        .then((invitations) {
      setState(() {
        collectionList = invitations;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return collectionList != null
        ? Container(
            child: Column(
              children: <Widget>[
                InvitationsList(
                  acceptHandler: acceptInvitation,
                  invitations: collectionList,
                  rejectHandler: rejectInvitation,
                )
              ],
            ),
          )
        : Text("");
  }
}
