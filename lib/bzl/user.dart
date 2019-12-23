import 'package:betterbetter/bzl/gameGroups.dart';
import 'package:betterbetter/models/gameGroup.dart';
import 'package:betterbetter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAPI {
  final userDB = Firestore.instance.collection("users");

  final gameGroupsAPI = GameGroupsAPI();

  Future<User> getById(userid) async {
    var document = await userDB.document(userid).get();
    return User.fromJson(document.data);
  }

  Future<String> getIdByEmail(userEmail) async {
    try {
      var documents = await userDB
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .getDocuments();
      return User.fromJson(documents.documents[0].data).id;
    } catch (err) {
      print("No user found with this email");
      return null;
    }
  }

  Future<Map<String, GameGroup>> getGameGroups(userId) async {
    var document = await userDB.document(userId).get();
    var gameGroupsIds = document.data["gameGroups"];
    Map<String, GameGroup> gameGroups = {};

    for (int i = 0; i < gameGroupsIds.length; i++) {
      gameGroups[gameGroupsIds[i]] =
          await gameGroupsAPI.getById(gameGroupsIds[i]);
    }
    return gameGroups;
  }

  Future<Map<String, GameGroup>> addToGameGroup(userId, gameGroupId) async {
    var document = await userDB.document(userId).get();
    var gameGroupsIds = document.data["gameGroups"];

    var newGameGroupsIds = new List<String>.from(gameGroupsIds);
    if (!newGameGroupsIds.contains(gameGroupId))
      newGameGroupsIds.add(gameGroupId);

    await userDB.document(userId).updateData({
      "gameGroups": newGameGroupsIds,
    });
    return await getGameGroups(userId);
  }
}
