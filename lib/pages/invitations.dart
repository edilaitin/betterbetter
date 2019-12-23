import 'package:betterbetter/drawer.dart';
import 'package:betterbetter/routes/invitations.dart';
import 'package:betterbetter/widgets/invitations/invitations.dart';
import 'package:flutter/material.dart';

class InvitationsPage extends StatefulWidget {
  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Invitations',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, InvitationsPageRoute());
            },
          )
        ],
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Colors.white,
          isScrollable: false,
          tabs: choices.map((Choice choice) {
            return Tab(
              text: choice.title,
              icon: Icon(choice.icon),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: choices.map((Choice choice) {
          return ChoiceCard(choice: choice);
        }).toList(),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon, this.widget});

  final String title;
  final IconData icon;
  final Widget widget;
}

List<Choice> choices = <Choice>[
  Choice(
    title: 'Friends',
    icon: Icons.person_add,
    widget: Invitations(
      collection: 'friends',
    ),
  ),
  Choice(
    title: 'Groups',
    icon: Icons.games,
    widget: Invitations(
      collection: 'groups',
    ),
  ),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          choice.widget,
        ],
      ),
    );
  }
}
