import 'dart:collection';

import 'package:betterbetter/bzl/user.dart';
import 'package:betterbetter/models/gameGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameGroupsAPI {
  final gameGroupsDB = Firestore.instance.collection("gameGroups");
  final groupInvitationsDB = Firestore.instance.collection("groupInvitations");
  final userDB = Firestore.instance.collection("users");

  Future<GameGroup> getById(groupid) async {
    var document = await gameGroupsDB.document(groupid).get();
    return GameGroup.fromMap(document.data);
  }

  Future<Map<dynamic, dynamic>> getLeaderboard(groupid) async {
    var document = await gameGroupsDB.document(groupid).get();
    Map<dynamic, dynamic> leaderboard = document.data["leaderboard"];

    var sortedKeys = leaderboard.keys.toList(growable: false)
      ..sort((k1, k2) => leaderboard[k2].compareTo(leaderboard[k1]));
    Map<dynamic, dynamic> sortedLeaderboard = new LinkedHashMap.fromIterable(
        sortedKeys,
        key: (k) => k,
        value: (k) => leaderboard[k]);
    return sortedLeaderboard;
  }

  Future<Map<String, GameGroup>> getGroupInvitations(userId) async {
    var document = await groupInvitationsDB.document(userId).get();
    if (document.exists) {
      var invitationsIDs = document.data["invitations"];
      Map<String, GameGroup> gameGroups = {};

      for (int i = 0; i < invitationsIDs.length; i++) {
        gameGroups[invitationsIDs[i]] = (await getById(invitationsIDs[i]));
      }
      return gameGroups;
    } else
      return {};
  }

  Future<GameGroup> addToGroup(groupid, userId) async {
    var document = await gameGroupsDB.document(groupid).get();

    if (document.exists) {
      var playersIds = List<String>.from(document.data["players"]);
      var leaderboard = document.data["leaderboard"];

      //finnaly add the friend
      if (!playersIds.contains(userId)) {
        playersIds.add(userId);
        leaderboard[userId] = 0;
      }

      var finalObject = {"players": playersIds, "leaderboard": leaderboard};

      await gameGroupsDB.document(groupid).updateData(finalObject);
      return await getById(groupid);
    } else {
      return null;
    }
  }

  Future<void> inviteToGroup(String groupId, String invitedUserId) async {
    var document = await groupInvitationsDB.document(invitedUserId).get();
    if (!document.exists) {
      groupInvitationsDB.document(invitedUserId).setData({
        "invitations": [
          groupId,
        ]
      });
    } else {
      var invitations = document.data["invitations"];

      var newInvitations = new List<String>.from(invitations);
      if (!newInvitations.contains(groupId)) newInvitations.add(groupId);

      groupInvitationsDB.document(invitedUserId).updateData({
        "invitations": newInvitations,
      });
    }
  }

  Future<List<dynamic>> removeInvitation(groupid, userId) async {
    var document = await groupInvitationsDB.document(userId).get();
    var invitationIds = document.data["invitations"];
    var newInvitationIds = [];

    for (int i = 0; i < invitationIds.length; i++) {
      if (invitationIds[i] != groupid) {
        newInvitationIds.add(invitationIds[i]);
      }
    }
    var finalObject = {"invitations": newInvitationIds};

    await groupInvitationsDB.document(userId).updateData(finalObject);
    var newDocument = await groupInvitationsDB.document(userId).get();

    return newDocument.data["invitations"];
  }

  Future<Map<String, GameGroup>> getGameGroups(userId) async {
    var document = await userDB.document(userId).get();
    var gameGroupsIds = document.data["gameGroups"];
    Map<String, GameGroup> gameGroups = {};

    for (int i = 0; i < gameGroupsIds.length; i++) {
      gameGroups[gameGroupsIds[i]] = await getById(gameGroupsIds[i]);
    }
    return gameGroups;
  }

  Future<Map<String, GameGroup>> addToGameGroup(userId, gameGroupId) async {
    var document = await userDB.document(userId).get();
    var gameGroupsIds = document.data["gameGroups"];
    var newGameGroupsIds = [];
    if (gameGroupsIds != null)
      newGameGroupsIds = new List<String>.from(gameGroupsIds);
    if (!newGameGroupsIds.contains(gameGroupId))
      newGameGroupsIds.add(gameGroupId);

    await userDB.document(userId).updateData({
      "gameGroups": newGameGroupsIds,
    });
    return await getGameGroups(userId);
  }

  Future<Map<String, GameGroup>> acceptGroupInvitation(groupid, userId) async {
    await addToGroup(groupid, userId);
    await addToGameGroup(userId, groupid);
    await removeInvitation(groupid, userId);

    return await getGroupInvitations(userId);
  }

  Future<Map<String, GameGroup>> rejectGroupInvitation(groupid, userId) async {
    await removeInvitation(groupid, userId);

    return await getGroupInvitations(userId);
  }
}
