import 'package:http/http.dart' as http;
import 'dart:convert';

class Standing {
  Filters filters;
  Competition competition;
  Season season;
  List<Standings> standings;

  Standing({this.filters, this.competition, this.season, this.standings});

  Standing.fromJson(Map<String, dynamic> json) {
    filters = json['filters'] != null ? new Filters.fromJson(json['filters']) : null;
    competition = json['competition'] != null ? new Competition.fromJson(json['competition']) : null;
    season = json['season'] != null ? new Season.fromJson(json['season']) : null;
    if (json['standings'] != null) {
      standings = new List<Standings>();
      json['standings'].forEach((v) { standings.add(new Standings.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filters != null) {
      data['filters'] = this.filters.toJson();
    }
    if (this.competition != null) {
      data['competition'] = this.competition.toJson();
    }
    if (this.season != null) {
      data['season'] = this.season.toJson();
    }
    if (this.standings != null) {
      data['standings'] = this.standings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Filters {


  Filters();

  Filters.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Competition {
  int id;
  Area area;
  String name;
  String code;
  String plan;
  String lastUpdated;

  Competition({this.id, this.area, this.name, this.code, this.plan, this.lastUpdated});

  Competition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    area = json['area'] != null ? new Area.fromJson(json['area']) : null;
    name = json['name'];
    code = json['code'];
    plan = json['plan'];
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.area != null) {
      data['area'] = this.area.toJson();
    }
    data['name'] = this.name;
    data['code'] = this.code;
    data['plan'] = this.plan;
    data['lastUpdated'] = this.lastUpdated;
    return data;
  }
}

class Area {
  int id;
  String name;

  Area({this.id, this.name});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Season {
  int id;
  String startDate;
  String endDate;
  int currentMatchday;
  Null winner;

  Season({this.id, this.startDate, this.endDate, this.currentMatchday, this.winner});

  Season.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    currentMatchday = json['currentMatchday'];
    winner = json['winner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['currentMatchday'] = this.currentMatchday;
    data['winner'] = this.winner;
    return data;
  }
}

class Standings {
  String stage;
  String type;
  Null group;
  List<Table> table;

  Standings({this.stage, this.type, this.group, this.table});

  Standings.fromJson(Map<String, dynamic> json) {
    stage = json['stage'];
    type = json['type'];
    group = json['group'];
    if (json['table'] != null) {
      table = new List<Table>();
      json['table'].forEach((v) { table.add(new Table.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stage'] = this.stage;
    data['type'] = this.type;
    data['group'] = this.group;
    if (this.table != null) {
      data['table'] = this.table.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table {
  int position;
  Team team;
  int playedGames;
  int won;
  int draw;
  int lost;
  int points;
  int goalsFor;
  int goalsAgainst;
  int goalDifference;

  Table({this.position, this.team, this.playedGames, this.won, this.draw, this.lost, this.points, this.goalsFor, this.goalsAgainst, this.goalDifference});

  Table.fromJson(Map<String, dynamic> json) {
    position = json['position'];
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
    playedGames = json['playedGames'];
    won = json['won'];
    draw = json['draw'];
    lost = json['lost'];
    points = json['points'];
    goalsFor = json['goalsFor'];
    goalsAgainst = json['goalsAgainst'];
    goalDifference = json['goalDifference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this.position;
    if (this.team != null) {
      data['team'] = this.team.toJson();
    }
    data['playedGames'] = this.playedGames;
    data['won'] = this.won;
    data['draw'] = this.draw;
    data['lost'] = this.lost;
    data['points'] = this.points;
    data['goalsFor'] = this.goalsFor;
    data['goalsAgainst'] = this.goalsAgainst;
    data['goalDifference'] = this.goalDifference;
    return data;
  }

  @override
  String toString() {
    return 'Table{position: $position, '
        'team: $team, '
        'playedGames: $playedGames, '
        'won: $won, '
        'draw: $draw, '
        'lost: $lost, '
        'points: $points, '
        'goalsFor: $goalsFor, '
        'goalsAgainst: $goalsAgainst, '
        'goalDifference: $goalDifference'
        '\n }';
  }


}

class Team {
  int id;
  String name;
  String crestUrl;

  Team({this.id, this.name, this.crestUrl});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    crestUrl = json['crestUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['crestUrl'] = this.crestUrl;
    return data;
  }

  @override
  String toString() {
    return 'Team{name: $name}';
  }


}


Future<List<Table>> main() async {
  var url = 'http://api.football-data.org/v2/competitions/2002/standings';

  var response = await http.get(url,
    headers: {
      'X-Auth-Token': 'cc439eb644a349bd8eb173e39ac82fce'
    });

  var parsedJson = json.decode(response.body);
  var standing = Standing.fromJson(parsedJson);

  List<Table> result = standing.standings[0].table;

  return result;
}
