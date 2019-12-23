import 'package:betterbetter/pages/friends.dart';
import 'package:betterbetter/pages/gameGroup.dart';
import 'package:flutter/material.dart';

class GameGroupPageRoute extends MaterialPageRoute<Null> {
  GameGroupPageRoute(String groupid)
      : super(builder: (BuildContext ctx) {
          return GameGroupPage(groupid);
        });
}
