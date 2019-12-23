import 'package:betterbetter/bzl/friends.dart';
import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:betterbetter/bzl/googleSignIn.dart';
import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/widgets/friends/invitationsList.dart' as friends;
import 'package:betterbetter/widgets/gameGroups/invitationsList.dart' as groups;

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
  final friendsApi = FriendsAPI();
  final groupsApi = GameGroupsAPI();
  _InvitationsState({this.collection});
  List friendInvites;
  Map<String, GameGroup> groupInvitations;

  @override
  void initState() {
    if (collection == "friends") {
      friendsApi.getFriendInvitations(gSignIn.currentUser.id).then((result) {
        setState(() {
          friendInvites = result;
        });
      });
    } else if (collection == "groups") {
      groupsApi.getGroupInvitations(gSignIn.currentUser.id).then((result) {
        setState(() {
          groupInvitations = result;
        });
      });
    }
  }

  void acceptInvitation(id) {
    if (collection == "friends") {
      friendsApi
          .acceptFriendInvitation(gSignIn.currentUser.id, id)
          .then((invitations) {
        setState(() {
          friendInvites = invitations;
        });
      });
    } else if (collection == "groups") {
      groupsApi
          .acceptGroupInvitation(id, gSignIn.currentUser.id)
          .then((invitations) {
        setState(() {
          groupInvitations = invitations;
        });
      });
    }
  }

  void rejectInvitation(id) {
    if (collection == "friends") {
      friendsApi
          .rejectFriendInvitation("friends", gSignIn.currentUser.id, id)
          .then((invitations) {
        setState(() {
          friendInvites = invitations;
        });
      });
    } else if (collection == "groups") {
      groupsApi
          .rejectGroupInvitation(id, gSignIn.currentUser.id)
          .then((invitations) {
        setState(() {
          groupInvitations = invitations;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (collection == "friends") {
      return friendInvites != null
          ? Container(
              child: Column(
                children: <Widget>[
                  friends.InvitationsList(
                    acceptHandler: acceptInvitation,
                    invitations: friendInvites,
                    rejectHandler: rejectInvitation,
                  )
                ],
              ),
            )
          : Text("");
    } else if (collection == "groups") {
      return groupInvitations != null
          ? Container(
              child: Column(
                children: <Widget>[
                  groups.InvitationsList(
                    acceptHandler: acceptInvitation,
                    invitations: groupInvitations,
                    rejectHandler: rejectInvitation,
                  )
                ],
              ),
            )
          : Text("");
    }
  }
}
