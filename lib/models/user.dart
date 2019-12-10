import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  String photoUrl;
  List<String> gameGroups = [];
  final usersDB = Firestore.instance.collection("users");

  User({
    this.id,
    this.name,
    this.email,
    this.photoUrl,
  });

  User.fromJson(Map<String, dynamic> jsonUser) {
    id = jsonUser['id'];
    name = jsonUser['name'];
    email = jsonUser['email'];
    photoUrl = jsonUser['photoUrl'];
  }

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "email": email,
      "id": id,
      "photoUrl": photoUrl,
      "gameGroups": gameGroups.toList(),
    };
  }

  void addUser() async {
    var document = await usersDB.document(id).get();
    if (!document.exists) {
      usersDB.document(id).setData(this.toJSON());
    }
  }
}
