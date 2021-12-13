import 'package:flutter/material.dart';
import 'package:tiesheet/leader_board/leaderboard.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tiesheet/matchtable/teampairing.dart';
import 'package:tiesheet/goal_table/goal_table.dart';
import 'package:tiesheet/tiesheet_database/tiesheet_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MatchTable extends StatefulWidget {
  final String value;

  MatchTable({Key key, @required this.value}) : super(key: key);

  @override
  _MatchTableState createState() => _MatchTableState();
}

class _MatchTableState extends State<MatchTable> {
  List teamPair = [];
  List<MatchGoalDetails> teamPairDB = [];
  List<String> _goal = [];
  String _awayGoalNumber = '';
  String _homeGoalNumber = '';
  String _awayTeam;
  String _homeTeam;
  String _matchName;
  int _currentPairId;
  String _matchResult = '';
  int currentPageIndex = 0;
  int initiateData = 0;

  void _getAllMatches() async {
    await MatchDetails.db.getGoalDetails(widget.value).then((goalList) {
      setState(() => teamPairDB = goalList);
    });
  }

  @override
  void initState() {
    _getAllMatches();
    super.initState();
  }

  String _capitalizeFirstString(val) {
    return (val.toUpperCase()[0] + val.substring(1));
  }

  String _trimName(val){
    if(val.length <= 10) return val;
    return (val.substring(0,10) + '..' );
  }

  List<String> addOptions() {
    if (_goal.isNotEmpty) _goal = [];
    for (var i = 0; i < 31; i++) {
      _goal.add('$i');
    }
    return _goal;
  }

  void _awayGoal(val) {
    setState(() => _awayGoalNumber = val);
  }

  void _homeGoal(val) {
    setState(() => _homeGoalNumber = val);
  }

  void _updateLeaderTable() async {
    String hT = _homeTeam;
    String aG = _awayGoalNumber;
    String hG = _homeGoalNumber;
    String aW = _awayTeam;
    String mN = _matchName;
    LeaderBoardDetails leaderBoardUpdate1;
    LeaderBoardDetails leaderBoardUpdate2;

    await MatchDetails.db
        .getTeamLeaderBoardDetails(mN, hT, aW)
        .then((goalList) {
      if (goalList.isEmpty) return;
      leaderBoardUpdate1 = LeaderBoardDetails(
          matchName: mN,
          teamNameHome: hT,
          teamNameAway: aW,
          played: 1,
          win: (int.parse(hG) > int.parse(aG)) ? 1 : 0,
          draw: (int.parse(hG) == int.parse(aG)) ? 1 : 0,
          loss: (int.parse(hG) < int.parse(aG)) ? 1 : 0,
          goalDifference: int.parse(hG) - int.parse(aG),
          points: (int.parse(hG) == int.parse(aG))
              ? 1
              : (int.parse(hG) > int.parse(aG)) ? 2 : 0);
    });

    await MatchDetails.db
        .getTeamLeaderBoardDetails(mN, aW, hT)
        .then((goalList) {
      if (goalList == null) return;
      leaderBoardUpdate2 = LeaderBoardDetails(
          matchName: mN,
          teamNameHome: aW,
          teamNameAway: hT,
          played: 1,
          win: (int.parse(aG) > int.parse(hG)) ? 1 : 0,
          draw: (int.parse(hG) == int.parse(aG)) ? 1 : 0,
          loss: (int.parse(hG) > int.parse(aG)) ? 1 : 0,
          goalDifference: int.parse(aG) - int.parse(hG),
          points: (int.parse(hG) == int.parse(aG))
              ? 1
              : (int.parse(hG) < int.parse(aG)) ? 2 : 0);
    });
    LeaderBoardDetails leaderBoard1 = LeaderBoardDetails(
        matchName: mN,
        teamNameHome: hT,
        teamNameAway: aW,
        played: 1,
        win: (int.parse(hG) > int.parse(aG)) ? 1 : 0,
        draw: (int.parse(hG) == int.parse(aG)) ? 1 : 0,
        loss: (int.parse(hG) < int.parse(aG)) ? 1 : 0,
        goalDifference: (int.parse(hG) - int.parse(aG)),
        points: (int.parse(hG) == int.parse(aG))
            ? 1
            : (int.parse(hG) > int.parse(aG)) ? 2 : 0);
    LeaderBoardDetails leaderBoard2 = LeaderBoardDetails(
        matchName: mN,
        teamNameHome: aW,
        teamNameAway: hT,
        played: 1,
        win: (int.parse(aG) > int.parse(hG)) ? 1 : 0,
        draw: (int.parse(hG) == int.parse(aG)) ? 1 : 0,
        loss: (int.parse(hG) > int.parse(aG)) ? 1 : 0,
        goalDifference: (int.parse(aG) - int.parse(hG)),
        points: (int.parse(hG) == int.parse(aG))
            ? 1
            : (int.parse(hG) < int.parse(aG)) ? 2 : 0);

    if (leaderBoardUpdate1 != null && leaderBoardUpdate2 != null) {
      await MatchDetails.db.updateLeaderBoardDetails(leaderBoardUpdate1);
      await MatchDetails.db.updateLeaderBoardDetails(leaderBoardUpdate2);
    } else {
      await MatchDetails.db.insertLeaderBoardDetails(leaderBoard1);
      await MatchDetails.db.insertLeaderBoardDetails(leaderBoard2);
    }
  }

  void _updateHelper() async {
    MatchGoalDetails match = MatchGoalDetails(
        id: _currentPairId,
        matchName: _matchName,
        teamName: _homeTeam,
        homeGoal: _homeGoalNumber == '' ? 0 : int.parse(_homeGoalNumber),
        opponent: _awayTeam,
        awayGoal: _awayGoalNumber == '' ? 0 : int.parse(_awayGoalNumber),
        matchResult: _matchResult);
    _updateLeaderTable();
    await MatchDetails.db.updateGoalDetails(match);
    await MatchDetails.db.getGoalDetails(widget.value).then((goalList) {
      setState(() => teamPairDB = goalList);
    });
  }

  void _updateGoalDB() {
    setState(() {
      _updateHelper();
    });
    _currentPairId = 0;
    _matchName = '';
    _homeTeam = '';
    _homeGoalNumber = '';
    _awayTeam = '';
    _awayGoalNumber = '';
    _matchResult = '';
    Navigator.pop(context);
  }

  void showSettingsPanel(val, index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
              ),
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      child: Text(
                        'Update the goal scored',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Center(
                    child: Text(
                        'Goal Scored By ${_trimName(_capitalizeFirstString(val[index].teamName))}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        )),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 0.0),
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: ListTile(
                        title: DropdownButton(
                          underline: SizedBox(),
                          focusColor: Colors.transparent,
                          hint: Text(_homeGoalNumber == ''
                              ? val[index].homeGoal.toString()
                              : _homeGoalNumber),
                          isExpanded: true,
                          items: addOptions()
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (selectVal) {
                            setModalState(() {
                              _homeGoalNumber = selectVal;
                              _homeTeam = val[index].teamName;
                              _homeGoal(selectVal);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: Text(
                        'Goal Scored By ${_trimName(_capitalizeFirstString(val[index].opponent))} ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        )),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 0.0),
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: ListTile(
                        title: DropdownButton(
                          underline: SizedBox(),
                          focusColor: Colors.transparent,
                          isExpanded: true,
                          hint: Text(_awayGoalNumber == ''
                              ? val[index].awayGoal.toString()
                              : _awayGoalNumber),
//                          value: _awayGoalNumber,
                          items: addOptions()
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (selectVal) {
                            setModalState(() {
                              _awayGoalNumber = selectVal;
                              _awayTeam = val[index].opponent;
                              _awayGoal(selectVal);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Container(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: RaisedButton(
                        padding: EdgeInsets.all(19.0),
                        color: Colors.red,
                        child: Text(
                          'Update Goal Scored',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        elevation: 0.0,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        onPressed: () {
                          setModalState(() {
                            _matchName = val[index].matchName;
                            _currentPairId = val[index].id;
                            if (_homeGoalNumber == '') {
                              _homeGoalNumber = val[index].homeGoal.toString();
                              _homeTeam = val[index].teamName;
                            }
                            if (_awayGoalNumber == '') {
                              _awayGoalNumber = val[index].awayGoal.toString();
                              _awayTeam = val[index].opponent;
                            }
                            _currentPairId = val[index].id;
                            _matchResult = (int.parse(_homeGoalNumber) ==
                                    int.parse(_awayGoalNumber))
                                ? 'draw'
                                : ((int.parse(_homeGoalNumber) >
                                        int.parse(_awayGoalNumber))
                                    ? 'home'
                                    : 'away');
//                              _matchResult = 'home';
                            _updateGoalDB();
                          });
                        }),
                  )),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0.0,
        title: Text('Match Table'),
      ),
      body: Container(
        child: teamPairDB == []
            ? SpinKitFadingCube(
                color: Colors.black26,
                size: 100.0,
              )
            : ListView.builder(
                itemCount: teamPairDB.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      onTap: () => showSettingsPanel(teamPairDB, index),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
//                       elevation:0.0,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
                            child: Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  '${_trimName(_capitalizeFirstString(teamPairDB[index].teamName))}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  '${teamPairDB[index].matchResult == 'draw' ? 'D ' : (teamPairDB[index].matchResult == 'home' ? 'W ' : (teamPairDB[index].matchResult == 'away' ? 'L ' : ''))}${teamPairDB[index].homeGoal} - ${teamPairDB[index].awayGoal} ${teamPairDB[index].matchResult == 'draw' ? ' D' : (teamPairDB[index].matchResult == 'away' ? ' W' : (teamPairDB[index].matchResult == 'home' ? 'L ' : ''))}',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${_trimName(_capitalizeFirstString(teamPairDB[index].opponent))}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ))),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}

class LinkMatchTableAndMatches extends StatefulWidget {
  final String value;

  LinkMatchTableAndMatches({Key key, @required this.value}) : super(key: key);

  @override
  _LinkMatchTableAndMatchesState createState() =>
      _LinkMatchTableAndMatchesState();
}

class _LinkMatchTableAndMatchesState extends State<LinkMatchTableAndMatches> {
  int currentPageIndex = 0;
  String matchName;
  List _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _widgetOptions = [
        MatchTable(value: widget.value),
        LeaderBoard(value: widget.value),
        GoalTable(value : widget.value)
      ];
    });
  }

  void _changePage(index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.grey[800],
              icon: Icon(Icons.directions_run),
              title: Text('Matches')),
          BottomNavigationBarItem(
              backgroundColor: Colors.grey[800],
              icon: Icon(Icons.assignment), title: Text('League Table')),
          BottomNavigationBarItem(
              backgroundColor: Colors.grey[800],
                icon: Icon(MdiIcons.trophy), title: Text('Goal Scored'))
        ],
        onTap: _changePage,
      ),
    );
  }
}
