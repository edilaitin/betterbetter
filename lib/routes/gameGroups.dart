import 'package:betterbetter/pages/friends.dart';
import 'package:betterbetter/pages/gameGroups.dart';
import 'package:flutter/material.dart';

class GameGroupsPageRoute extends MaterialPageRoute<Null> {
  GameGroupsPageRoute()
      : super(builder: (BuildContext ctx) {
          return GameGroupsPage();
        });
}
