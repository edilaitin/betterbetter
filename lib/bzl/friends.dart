import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:betterbetter/bzl/user.dart';
import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsAPI {
  UserAPI userAPI = UserAPI();
  GameGroupsAPI gameGroupsAPI = GameGroupsAPI();
  final friendsDB = Firestore.instance.collection("friends");
  final friendInvitationsDB =
      Firestore.instance.collection("friendInvitations");
  final groupInvitationsDB = Firestore.instance.collection("groupInvitations");

  Future<List<User>> getFriends(userId) async {
    var document = await friendsDB.document(userId).get();
    if (document.exists) {
      var friendsIDs = document.data["friends"];
      List<User> friends = [];

      //remove the friend from the list
      for (int i = 0; i < friendsIDs.length; i++) {
        friends.add(await userAPI.getById(friendsIDs[i]));
      }
      return friends;
    } else {
      friendsDB.document(userId).setData({"friends": []});
      return [];
    }
  }

  Future<List<User>> addFriend(userId, friendId) async {
    var document = await friendsDB.document(userId).get();

    if (document.exists) {
      var friendsIds = document.data["friends"];
      var newFriendsIds = [];

      for (int i = 0; i < friendsIds.length; i++) {
        newFriendsIds.add(friendsIds[i]);
      }
      //finnaly add the friend
      if (!newFriendsIds.contains(friendId)) newFriendsIds.add(friendId);

      var finalObject = {"friends": newFriendsIds};

      await friendsDB.document(userId).updateData(finalObject);
      return await getFriends(userId);
    } else {
      friendsDB.document(userId).setData({"friends": []});
      return [];
    }
  }

  Future<List<User>> removeFriend(userId, friendId) async {
    var document = await friendsDB.document(userId).get();
    var friendsIds = document.data["friends"];
    var newFriendsIds = [];

    for (int i = 0; i < friendsIds.length; i++) {
      if (friendsIds[i] != friendId) {
        newFriendsIds.add(friendsIds[i]);
      }
    }
    var finalObject = {"friends": newFriendsIds};

    await friendsDB.document(userId).updateData(finalObject);
    return await getFriends(userId);
  }

  Future<void> inviteFriend(String userId, String invitedUserEmail) async {
    invitedUserEmail = invitedUserEmail.trim();
    var invitedUserId = await userAPI.getIdByEmail(invitedUserEmail);
    if (invitedUserId == null) return;

    var document = await friendInvitationsDB.document(invitedUserId).get();
    if (!document.exists) {
      friendInvitationsDB.document(invitedUserId).setData({
        "invitations": [
          userId,
        ]
      });
    } else {
      var invitations = document.data["invitations"];

      var newInvitations = new List<String>.from(invitations);
      if (!newInvitations.contains(userId)) newInvitations.add(userId);

      friendInvitationsDB.document(invitedUserId).updateData({
        "invitations": newInvitations,
      });
    }
  }

  Future<List<User>> getFriendInvitations(userId) async {
    var document = await friendInvitationsDB.document(userId).get();
    if (document.exists) {
      var invitationsIDs = document.data["invitations"];
      List<User> users = [];

      for (int i = 0; i < invitationsIDs.length; i++) {
        users.add(await userAPI.getById(invitationsIDs[i]));
      }
      return users;
    } else
      return [];
  }

  Future<List<dynamic>> removeInvitation(
      collection, userId, invitationId) async {
    CollectionReference db;
    if (collection == 'friends')
      db = friendInvitationsDB;
    else if (collection == 'groups') db = groupInvitationsDB;

    var document = await db.document(userId).get();
    var invitationIds = document.data["invitations"];
    var newInvitationIds = [];

    for (int i = 0; i < invitationIds.length; i++) {
      if (invitationIds[i] != invitationId) {
        newInvitationIds.add(invitationIds[i]);
      }
    }
    var finalObject = {"invitations": newInvitationIds};

    await db.document(userId).updateData(finalObject);
    var newDocument = await db.document(userId).get();

    return newDocument.data["invitations"];
  }

  Future<List<User>> acceptFriendInvitation(userId, newFriendId) async {
    addFriend(newFriendId, userId);
    addFriend(userId, newFriendId);
    await removeInvitation('friends', userId, newFriendId);

    return await getFriendInvitations(userId);
  }

  Future<List<User>> rejectFriendInvitation(
      collection, userId, invitationId) async {
    await removeInvitation(collection, userId, invitationId);
    return await getFriendInvitations(userId);
  }
}
