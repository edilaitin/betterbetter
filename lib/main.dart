import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'testApi.dart' as testApi;
import 'dart:ui';

var cachedTeams;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: RandomWords(),
      theme: ThemeData(
        primaryColor: Colors.black,
      )
    );
  }
}

class RandomWordsState extends State<RandomWords> {

  Set<testApi.Table> _saved = Set<testApi.Table>();
  List<testApi.Table> _suggestions = List<testApi.Table>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WTF IS THIS'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: FutureBuilder(
        future: testApi.main(),
        builder: (context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData)
              snapshot = cachedTeams;
            else cachedTeams = snapshot;

              return _buildSuggestions(snapshot);
            }
      )
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) {
            final Iterable<Card> tiles = _saved.map(
                  (testApi.Table team) {
                    print(team.team.crestUrl);
                return Card(
                  child: Row(
                    children: [
                      Container(
                          height: 50
                      ),
                      Text(team.position.toString()),
                      Text("  " + team.team.name + "  "),
                      Text(team.points.toString()),
                    ]
                  ),
                );
              },
            );
            final List<Widget> divided = ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggestions'),
              ),
              body: ListView(children: divided),
            );
          },
      ),
    );
  }

  Widget _buildSuggestions(AsyncSnapshot snapshot) {
      List<testApi.Table> teams = cachedTeams.data;
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 18,
        itemBuilder:(context, i) {
          _suggestions.add(teams[i]);
          return _buildRow(_suggestions[i]);
        });
  }

  Widget _buildRow(testApi.Table team) {
    final bool alreadySaved = _saved.contains(team);

    return ListTile(
      title: Text(
        team.team.name,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.black : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(team);
          } else {
            _saved.add(team);
          }
        });
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}