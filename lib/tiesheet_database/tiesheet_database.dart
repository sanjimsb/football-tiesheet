import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';

class MatchDetails {
  static const String tableNameForMatches = "Matches";
  static const String columnMatches = "MatchName";
  static const String columnNumberOfTeams = "NumberOfTeams";
  static const String columnMatchesId = "id";

  static const String tableName = "TieSheet";
  static const String columnId = "id";
  static const String columnName1 = "MatchName";
  static const String columnName2 = "TeamName";

  static const String tableNameForGoals = "GoalLeaderBoard";
  static const String columnIdGoal = "id";
  static const String columnName1Goal = "PlayerName";
  static const String columnName2Goal = "MatchName";
  static const String columnName3Goal = "TeamName";
  static const String columnName4Goal = "NumberOfGoals";

  static const String tbName = "GoalDetails";
  static const String colId = "id";
  static const String col2 = "TeamName";
  static const String col1 = "MatchName";
  static const String col3 = "HomeGoal";
  static const String col4 = "Opponent";
  static const String col5 = "AwayGoal";
  static const String col6 = "MatchResult";

  static const String leaderBoardTbName = "LeaderBoard";
  static const String lColId = "id";
  static const String lCol1 = "MatchName";
  static const String lCol2 = "TeamNameHome";
  static const String lCol3 = "TeamNameAway";
  static const String lCol4 = "Played";
  static const String lCol5 = "Win";
  static const String lCol6 = "Draw";
  static const String lCol7 = "Loose";
  static const String lCol8 = "GoalDifference";
  static const String lCol9 = "Points";

  MatchDetails._();

  static final MatchDetails db = MatchDetails._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(join(dbPath, 'tsheetdv16.db'), version: 16,
        onCreate: (Database database, int version) async {
      await database.execute(
        "CREATE TABLE $tableName("
        "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$columnName1 TEXT,"
        "$columnName2 TEXT"
        ")",
      );
      await database.execute(
        "CREATE TABLE $tbName("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$col1 TEXT,"
        "$col2 TEXT,"
        "$col3 INTEGER,"
        "$col4 TEXT,"
        "$col5 INTEGER,"
        "$col6 TEXT"
        ")",
      );
      await database.execute(
        "CREATE TABLE $leaderBoardTbName("
        "$lColId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$lCol1 TEXT,"
        "$lCol2 TEXT,"
        "$lCol3 TEXT,"
        "$lCol4 INTEGER,"
        "$lCol5 INTEGER,"
        "$lCol6 INTEGER,"
        "$lCol7 INTEGER,"
        "$lCol8 INTEGER,"
        "$lCol9 INTEGER"
        ")",
      );
      await database.execute(
        "CREATE TABLE $tableNameForMatches("
        "$columnMatchesId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$columnMatches TEXT,"
        "$columnNumberOfTeams TEXT"
        ")",
      );
      await database.execute(
        "CREATE TABLE $tableNameForGoals("
        "$columnIdGoal INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$columnName1Goal TEXT,"
        "$columnName2Goal TEXT,"
        "$columnName3Goal TEXT,"
        "$columnName4Goal INTEGER"
        ")",
      );
    });
  }

  Future<List<MatchInfo>> getMatch(matchN) async {
    final db = await database;
    var match = await db.query(tableName,
        columns: [columnId, columnName1, columnName2],
        where: '"$columnName1" = ?',
        whereArgs: [matchN]);
    List<MatchInfo> matchInfoList = List<MatchInfo>();
    match.forEach((currentMatch) {
      MatchInfo match = MatchInfo.fromMap(currentMatch);

      matchInfoList.add(match);
    });
    return matchInfoList;
  }

  Future<List<AllMatches>> getAllMatches() async {
    final db = await database;
    var match = await db.query(tableNameForMatches,
        columns: [columnMatchesId, columnMatches, columnNumberOfTeams]);
    List<AllMatches> allMatches = List<AllMatches>();
    match.forEach((individualMatch) {
      AllMatches match = AllMatches.fromMap(individualMatch);
      allMatches.add(match);
    });
    return allMatches;
  }

  Future<List<MatchGoalDetails>> getGoalDetails(matchN) async {
    final db = await database;
    var goalDetails = await db.query(tbName,
        columns: [colId, col1, col2, col3, col4, col5, col6],
        where: '"$col1" = ?',
        whereArgs: [matchN]);
    List<MatchGoalDetails> goalDetailsInfo = List<MatchGoalDetails>();
    goalDetails.forEach((goalsIndividualTeams) {
      MatchGoalDetails goals = MatchGoalDetails.fromMap(goalsIndividualTeams);

      goalDetailsInfo.add(goals);
    });
    return goalDetailsInfo;
  }

  Future<List<GoalDetails>> getGoalScored(matchN) async {
    final db = await database;
    var goalScored = await db.query(tableNameForGoals,
        columns: [
          columnIdGoal,
          columnName1Goal,
          columnName2Goal,
          columnName3Goal,
          columnName4Goal
        ],
        where: '"$columnName2Goal" = ?',
        whereArgs: [matchN],
        orderBy: "$columnName4Goal DESC");
    List<GoalDetails> goalDetailsInfo = List<GoalDetails>();
    goalScored.forEach((goalsIndividualTeams) {
      print(goalsIndividualTeams);
      GoalDetails goals = GoalDetails.fromMap(goalsIndividualTeams);

      goalDetailsInfo.add(goals);
    });
    return goalDetailsInfo;
  }

  Future<List<GoalDetails>> updateGoalScoredByIndividual(
      matchN, teamN, playerN) async {
    final db = await database;
    var goalScored = await db.query(tableNameForGoals,
        columns: [
          columnIdGoal,
          columnName1Goal,
          columnName2Goal,
          columnName3Goal,
          columnName4Goal
        ],
        where:
            '$columnName1Goal = ? and $columnName2Goal = ? and $columnName3Goal = ?',
        whereArgs: [playerN, matchN, teamN]);
    List<GoalDetails> goalDetailsInfo = List<GoalDetails>();
    goalScored.forEach((goalsIndividualTeams) {
      print(goalsIndividualTeams);
      GoalDetails goals = GoalDetails.fromMap(goalsIndividualTeams);

      goalDetailsInfo.add(goals);
    });
    return goalDetailsInfo;
  }

  Future<List<LeaderBoardDetails>> getLeaderBoardDetails(matchN) async {
    final db = await database;
    var leaderBoardInfo = await db.query(leaderBoardTbName,
        columns: [
          lColId,
          lCol1,
          lCol2,
          lCol3,
          lCol4,
          lCol5,
          lCol6,
          lCol7,
          lCol8,
          lCol9
        ],
        where: '"$col1" = ?',
        whereArgs: [matchN],
        orderBy: "$lCol8 ASC");
    List<LeaderBoardDetails> leaderBoardDetailsInfo =
        List<LeaderBoardDetails>();
    leaderBoardInfo.forEach((lBInfo) {
      LeaderBoardDetails goals = LeaderBoardDetails.fromMap(lBInfo);

      leaderBoardDetailsInfo.add(goals);
    });
    return leaderBoardDetailsInfo;
  }

  Future<List<LeaderBoardDetails>> getTeamLeaderBoardDetails(
      matchN, teamNHm, teamNAw) async {
    final db = await database;
    var leaderBoardInfo = await db.query(leaderBoardTbName,
        columns: [
          lColId,
          lCol1,
          lCol2,
          lCol3,
          lCol4,
          lCol5,
          lCol6,
          lCol7,
          lCol8,
          lCol9
        ],
        where: '$lCol1 = ? and $lCol2 = ? and $lCol3 = ?',
        whereArgs: [matchN, teamNHm, teamNAw]);
    if (leaderBoardInfo.isEmpty) return null;
    List<LeaderBoardDetails> leaderBoardDetailsInfo =
        List<LeaderBoardDetails>();
    leaderBoardInfo.forEach((lBInfo) {
      LeaderBoardDetails goals = LeaderBoardDetails.fromMap(lBInfo);
      leaderBoardDetailsInfo.add(goals);
    });
    return leaderBoardDetailsInfo;
  }

  Future<MatchInfo> insert(MatchInfo match) async {
    final db = await database;
    match.id = await db.insert(tableName, match.toMap());
    return match;
  }

  Future<GoalDetails> insertGoalScored(GoalDetails goal) async {
    final db = await database;
    goal.id = await db.insert(tableNameForGoals, goal.toMap());
    return goal;
  }

  Future<AllMatches> insertMatchName(AllMatches match) async {
    final db = await database;
    match.id = await db.insert(tableNameForMatches, match.toMap());
    return match;
  }

  Future<MatchGoalDetails> insertGoalDetails(MatchGoalDetails goals) async {
    final db = await database;
    goals.id = await db.insert(tbName, goals.toMap());
    return goals;
  }

  Future<LeaderBoardDetails> insertLeaderBoardDetails(
      LeaderBoardDetails leaderBoardTableDetails) async {
    final db = await database;
    leaderBoardTableDetails.id =
        await db.insert(leaderBoardTbName, leaderBoardTableDetails.toMap());
    return leaderBoardTableDetails;
  }

  Future<MatchGoalDetails> updateGoalDetails(MatchGoalDetails goals) async {
    final db = await database;
    goals.id = await db.update(tbName, goals.toMap(),
        where: '$colId=?', whereArgs: [goals.id]);
    return goals;
  }

  Future<LeaderBoardDetails> updateLeaderBoardDetails(
      LeaderBoardDetails leaderBoardTableDetails) async {
    final db = await database;
    leaderBoardTableDetails.id = await db.update(
        leaderBoardTbName, leaderBoardTableDetails.toMap(),
        where: '$lCol1=? and $lCol2=? and $lCol3=?',
        whereArgs: [
          leaderBoardTableDetails.matchName,
          leaderBoardTableDetails.teamNameHome,
          leaderBoardTableDetails.teamNameAway,
        ]);
    return leaderBoardTableDetails;
  }

  Future<GoalDetails> updateGoalScoredByIndividualPlayer(
      GoalDetails goalDetailsId) async {
    final db = await database;
    goalDetailsId.id = await db.update(tableNameForGoals, goalDetailsId.toMap(),
        where:
            '$columnName1Goal=? and $columnName2Goal=? and $columnName3Goal=?',
        whereArgs: [
          goalDetailsId.playerName,
          goalDetailsId.matchName,
          goalDetailsId.teamName
        ]);
    return goalDetailsId;
  }

  Future<List<int>> deleteMatchDetails(matchName) async {
    final db = await database;
    return [
      await db.delete(tableNameForMatches,
          where: '$columnMatches = ?', whereArgs: [matchName]),
      await db
          .delete(tableName, where: '$columnName1 = ?', whereArgs: [matchName]),
      await db.delete(tbName, where: '$col1 = ?', whereArgs: [matchName]),
      await db.delete(leaderBoardTbName,
          where: '$lCol1 = ?', whereArgs: [matchName]),
      await db.delete(tableNameForGoals,
          where: '$columnName2Goal = ?', whereArgs: [matchName])
    ];
  }

  Future<List<AllMatches>> checkIfMatchAlreadyExists(matchName) async {
    final db = await database;
    var match = await db.query(tableNameForMatches,
        columns: [columnMatchesId, columnMatches, columnNumberOfTeams],
        where: '$columnMatches = ?',
        whereArgs: [matchName]);
    List<AllMatches> allMatches = List<AllMatches>();
    match.forEach((individualMatch) {
      AllMatches match = AllMatches.fromMap(individualMatch);
      allMatches.add(match);
    });
    return allMatches;
  }

//  Future<List<MatchInfo>> getMatchList() async {
//    var matchMapList = await getMatch();
//    int count = matchMapList.length;
//    List<MatchInfo> listOfMatch = List<MatchInfo>();
//    for (int i = 0; i < count; i++) {
//      listOfMatch.add(matchMapList[i]);
//    }
//    return listOfMatch;
//  }
}

//class DeleteMethod extends MatchDetails{
//  String matchName;
//  DeleteMethod({this.matchName}) : super(key : key);
//
//  Future<int> deleteMatchDetails(String matchName) async {
//    final db = await database;
//    return await db.delete(MatchDetails.tableNameForMatches, where: '${MatchDetails.columnMatches} = ?', whereArgs: [matchName]);
//  }
//}

class MatchInfo {
  int id;
  String matchName;
  String teamName;

  MatchInfo({this.id, this.matchName, this.teamName});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      MatchDetails.columnName1: matchName,
      MatchDetails.columnName2: teamName,
    };
    if (id != null) {
      map[MatchDetails.columnId] = id;
    }
    return map;
  }

  MatchInfo.fromMap(Map<String, dynamic> map) {
    id = map[MatchDetails.columnId];
    matchName = map[MatchDetails.columnName1];
    teamName = map[MatchDetails.columnName2];
  }
}

class MatchGoalDetails {
  int id;
  String matchName;
  String teamName;
  int homeGoal;
  String opponent;
  int awayGoal;
  String matchResult;

  MatchGoalDetails(
      {this.id,
      this.matchName,
      this.teamName,
      this.homeGoal,
      this.opponent,
      this.awayGoal,
      this.matchResult});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      MatchDetails.col1: matchName,
      MatchDetails.col2: teamName,
      MatchDetails.col3: homeGoal,
      MatchDetails.col4: opponent,
      MatchDetails.col5: awayGoal,
      MatchDetails.col6: matchResult,
    };
    if (id != null) map[MatchDetails.colId] = id;
    return map;
  }

  MatchGoalDetails.fromMap(Map<String, dynamic> map) {
    id = map[MatchDetails.colId];
    matchName = map[MatchDetails.col1];
    teamName = map[MatchDetails.col2];
    homeGoal = map[MatchDetails.col3];
    opponent = map[MatchDetails.col4];
    awayGoal = map[MatchDetails.col5];
    matchResult = map[MatchDetails.col6];
  }
}

class LeaderBoardDetails {
  int id;
  String matchName;
  String teamNameHome;
  String teamNameAway;
  int played;
  int win;
  int draw;
  int loss;
  int goalDifference;
  int points;

  LeaderBoardDetails(
      {this.id,
      this.matchName,
      this.teamNameHome,
      this.teamNameAway,
      this.played,
      this.win,
      this.draw,
      this.loss,
      this.goalDifference,
      this.points});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      MatchDetails.lCol1: matchName,
      MatchDetails.lCol2: teamNameHome,
      MatchDetails.lCol3: teamNameAway,
      MatchDetails.lCol4: played,
      MatchDetails.lCol5: win,
      MatchDetails.lCol6: draw,
      MatchDetails.lCol7: loss,
      MatchDetails.lCol8: goalDifference,
      MatchDetails.lCol9: points,
    };
    if (id != null) map[MatchDetails.lColId] = id;
    return map;
  }

  LeaderBoardDetails.fromMap(Map<String, dynamic> map) {
    id = map[MatchDetails.lColId];
    matchName = map[MatchDetails.lCol1];
    teamNameHome = map[MatchDetails.lCol2];
    teamNameAway = map[MatchDetails.lCol3];
    played = map[MatchDetails.lCol4];
    win = map[MatchDetails.lCol5];
    draw = map[MatchDetails.lCol6];
    loss = map[MatchDetails.lCol7];
    goalDifference = map[MatchDetails.lCol8];
    points = map[MatchDetails.lCol9];
  }
}

class AllMatches {
  int id;
  String matchName;
  String numberOfTeams;

  AllMatches({this.id, this.matchName, this.numberOfTeams});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      MatchDetails.columnMatches: matchName,
      MatchDetails.columnNumberOfTeams: numberOfTeams,
    };
    return map;
  }

  AllMatches.fromMap(Map<String, dynamic> map) {
    matchName = map[MatchDetails.columnMatches];
    numberOfTeams = map[MatchDetails.columnNumberOfTeams];
  }
}

class GoalDetails {
  int id;
  String playerName;
  String matchName;
  String teamName;
  int numberOfGoals;

  GoalDetails(
      {this.id,
      this.playerName,
      this.matchName,
      this.teamName,
      this.numberOfGoals});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      MatchDetails.columnName1Goal: playerName,
      MatchDetails.columnName2Goal: matchName,
      MatchDetails.columnName3Goal: teamName,
      MatchDetails.columnName4Goal: numberOfGoals
    };
    return map;
  }

  GoalDetails.fromMap(Map<String, dynamic> map) {
    id = map[MatchDetails.columnIdGoal];
    playerName = map[MatchDetails.columnName1Goal];
    matchName = map[MatchDetails.columnName2Goal];
    teamName = map[MatchDetails.columnName3Goal];
    numberOfGoals = map[MatchDetails.columnName4Goal];
  }
}
