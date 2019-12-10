import 'package:betterbetter/models/gameGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameGroupsAPI {
  final gameGroupsDB = Firestore.instance.collection("gameGroups");

  Future<GameGroup> getById(gameGroupId) async {
    var document = await gameGroupsDB.document(gameGroupId).get();
    return GameGroup.fromMap(document.data);
  }
}
