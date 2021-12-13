import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiesheet/drawer/drawer.dart';
import 'package:tiesheet/drawer/guitardrawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tiesheet/matchtable/teampairing.dart';
import 'package:tiesheet/tiesheet/tiesheet.dart';
import 'package:tiesheet/tiesheet_database/tiesheet_database.dart';
import 'package:tiesheet/matchtable/matchtable.dart';

class League extends StatefulWidget {
  @override
  _LeagueState createState() => _LeagueState();
}

class _LeagueState extends State<League> {
  bool selectedRadioTile;
  String _teams = '0';
  String _mName;
  String _hold;
  String _test;
  final _formKey = GlobalKey<FormState>();
  List<String> _teamsOption = [];
  List<String> _teamNames = [];
  List<String> _enteredTeamNames = [];
  bool _dropdownHasValue = true;
  List<MatchInfo> listOfMatch;
  List _alreadyExists = [];
  String team1;
  String team2;
  String team3;
  String team4;
  String team5;
  String team6;
  String team7;
  String team8;
  String team9;
  String team10;
  String team11;
  String team12;
  String team13;
  String team14;
  String team15;
  String team16;
  String team17;
  String team18;
  String team19;
  String team20;
  String team21;
  String team22;
  String team23;
  String team24;
  String team25;
  String team26;
  String team27;
  String team28;
  String team29;
  String team30;

  @override
  void initState() {
    super.initState();
    if (listOfMatch == null) {
      listOfMatch = List<MatchInfo>();
    }
    selectedRadioTile = false;
    _getAllMatches();
  }

  void _getAllMatches() async{
    await MatchDetails.db.getAllMatches().then((matches) {
      for(var i=0;i<matches.length;i++){
        _alreadyExists.add(matches[i].matchName.toLowerCase());
      }
    });
  }

  void checkNotNull(val) {
    if (val == null) return;
    _teamNames.add(val);
  }

  List addToList() {
    _teamNames = [];
    checkNotNull(team1);
    checkNotNull(team2);
    checkNotNull(team3);
    checkNotNull(team4);
    checkNotNull(team5);
    checkNotNull(team6);
    checkNotNull(team7);
    checkNotNull(team8);
    checkNotNull(team9);
    checkNotNull(team10);
    checkNotNull(team11);
    checkNotNull(team12);
    checkNotNull(team13);
    checkNotNull(team14);
    checkNotNull(team15);
    checkNotNull(team16);
    checkNotNull(team17);
    checkNotNull(team18);
    checkNotNull(team19);
    checkNotNull(team20);
    checkNotNull(team21);
    checkNotNull(team22);
    checkNotNull(team23);
    checkNotNull(team24);
    checkNotNull(team25);
    checkNotNull(team26);
    checkNotNull(team27);
    checkNotNull(team28);
    checkNotNull(team29);
    checkNotNull(team30);
    return _teamNames;
  }

  void _saveIntoDatabase() async {
    if(_mName == null ) return;
    if(_teams == '0') {setState(() =>_dropdownHasValue = false); return;}
    if(addToList().isEmpty && selectedRadioTile == false) {setState(() =>_test = 'notselected'); return;}
    if((addToList().length != int.parse(_teams)) && selectedRadioTile == false){setState(() => _test = 'notall'); return;}
    if ((addToList() == [] && selectedRadioTile == false )|| (addToList().length != int.parse(_teams) && selectedRadioTile == false )) return;
    AllMatches match = AllMatches(matchName: _mName, numberOfTeams: _teams);
    await MatchDetails.db.insertMatchName(match);
    if (selectedRadioTile == true) {
      for (var i = 1; i <= (int.parse(_teams)); i++) {
        MatchInfo match = MatchInfo(matchName: _mName, teamName: 'team $i');
        await MatchDetails.db.insert(match);
      }
    } else {
      if(addToList() == [] && selectedRadioTile == false) {setState(() =>_test = 'notselected'); return;}
      if(addToList().length != int.parse(_teams) && selectedRadioTile == false){setState(() => _test = "notall"); return;}
      for (var i = 0; i < (int.parse(_teams)); i++) {
        MatchInfo match =
            MatchInfo(matchName: _mName, teamName: addToList()[i]);
        await MatchDetails.db.insert(match);
      }
    }
    if (_mName != null) {
      List matches = [];
      await MatchDetails.db.getMatch(_mName).then((matchList) {
        for (var i = 0; i < matchList.length; i++) {
          matches.add(matchList[i].teamName);
        }
      });
      List teamPairDatabase = TeamPairing().allPossiblePairing(matches);
      for (var i = 0; i < teamPairDatabase.length; i++) {
        MatchGoalDetails goals = MatchGoalDetails(
            matchName: _mName,
            teamName: teamPairDatabase[i][0],
            homeGoal: 0,
            opponent: teamPairDatabase[i][1],
            awayGoal: 0,
            matchResult: '');

        LeaderBoardDetails leaderBoard1 = LeaderBoardDetails(
            matchName: _mName,
            teamNameHome: teamPairDatabase[i][0],
            teamNameAway: teamPairDatabase[i][1],
            played: 0,
            win: 0,
            draw: 0,
            loss: 0,
            goalDifference: 0,
            points:0);
        LeaderBoardDetails leaderBoard2 = LeaderBoardDetails(
            matchName: _mName,
            teamNameHome: teamPairDatabase[i][1],
            teamNameAway: teamPairDatabase[i][0],
            played: 0,
            win: 0,
            draw: 0,
            loss: 0,
            goalDifference: 0,
            points:0);

        await MatchDetails.db.insertGoalDetails(goals);
        await MatchDetails.db.insertLeaderBoardDetails(leaderBoard1);
        await MatchDetails.db.insertLeaderBoardDetails(leaderBoard2);
      }
    }
    var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
            LinkMatchTableAndMatches(value: _mName));
    Navigator.of(context).pushReplacement(route);
  }

  void _saveMatchName(val) {
    setState(() => _mName = val);
  }

  void setSelectedRadio(bool val) {
    setState(() => selectedRadioTile = val);
  }

  void _allTeamNames(val, index) {
    if (index == 0)
      team1 = val;
    else if (index == 1)
      team2 = val;
    else if (index == 2)
      team3 = val;
    else if (index == 3)
      team4 = val;
    else if (index == 4)
      team5 = val;
    else if (index == 5)
      team6 = val;
    else if (index == 6)
      team7 = val;
    else if (index == 7)
      team8 = val;
    else if (index == 8)
      team9 = val;
    else if (index == 9)
      team10 = val;
    else if (index == 10)
      team11 = val;
    else if (index == 11)
      team12 = val;
    else if (index == 12)
      team13 = val;
    else if (index == 13)
      team14 = val;
    else if (index == 14)
      team15 = val;
    else if (index == 15)
      team16 = val;
    else if (index == 16)
      team17 = val;
    else if (index == 17)
      team18 = val;
    else if (index == 18)
      team19 = val;
    else if (index == 19)
      team20 = val;
    else if (index == 20)
      team21 = val;
    else if (index == 21)
      team22 = val;
    else if (index == 22)
      team23 = val;
    else if (index == 23)
      team24 = val;
    else if (index == 24)
      team25 = val;
    else if (index == 25)
      team26 = val;
    else if (index == 26)
      team27 = val;
    else if (index == 27)
      team28 = val;
    else if (index == 28)
      team29 = val;
    else if (index == 29) team30 = val;
  }

  List<String> addOptions() {
    if (_teamsOption.isNotEmpty) _teamsOption = [];
    for (var i = 1; i < 31; i++) {
      _teamsOption.add('$i');
    }
    return _teamsOption;
  }

  void _numberOfTeams(val) {
    if(val == null) return;
    _dropdownHasValue = true;
    setState(() => _teams = val);
    }

  double _heightForTeamsInput() {
    double heightTeams;
    if (int.parse(_teams) == 1)
      heightTeams = 55.0;
    else if (int.parse(_teams) == 2)
      heightTeams = 100.0;
    else if (int.parse(_teams) == 3)
      heightTeams = 150.0;
    else
      heightTeams = 200.0;
    return heightTeams;
  }

  dynamic _limitScroll() {
    if (int.parse(_teams) == 1 ||
        int.parse(_teams) == 2 ||
        int.parse(_teams) == 3 ||
        int.parse(_teams) == 4) {
      return NeverScrollableScrollPhysics();
    } else {
      return AlwaysScrollableScrollPhysics();
    }
  }

  List<String> _teamName() {
    for (var i = 1; i <= (int.parse(_teams)); i++) {
      _teamNames.add('$i');
    }
    return _teamNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text('League Match'),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 40.0),
              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                      fontSize: 16.0,
                    ),
                    hintText: "Match Name",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    prefixIcon: Icon(MdiIcons.trophy),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                  validator: (val){
                    if(val == '')
                      return 'Please enter the Match Name';
                    else if(_alreadyExists.contains(val.toLowerCase()))
                      return 'Match Name you entered alread exists';
                    else if(val.length < 6)
                      return 'Match Name should atleast be of 6 character';
                    else
                      return null;
                  },
                  onChanged: (val) => _saveMatchName(val),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
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
                      hint: _teams == '0'
                          ? Text('Number of teams')
                          : Text('$_teams teams'),
                      isExpanded: true,
                      items: addOptions()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) => _numberOfTeams(val),
                    ),
                  ),
                ),
              ),
              _dropdownHasValue == false ?
              Padding(
                  padding: EdgeInsets.fromLTRB(28.0, 8.0, 18.0, 0.0),
                  child: Text(
                    'Choose the number of teams',
                    style: TextStyle(
                        color: Colors.redAccent.shade700, fontSize: 16.0),
                  )) : SizedBox(),
              SizedBox(height: 20.0),
              _teams == '0'
                  ? SizedBox()
                  : Container(
                      child: Center(
                        child: Text(
                          'Enter the team names',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 10.0),
              _teams == '0'
                  ? SizedBox(height: 0.0)
                  : Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                      child: Container(
                          height: _heightForTeamsInput(),
                          child: ListView.builder(
                              physics: _limitScroll(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: int.parse(_teams),
                              itemBuilder: (context, index) {
                                return (Container(
                                  height: 50.0,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                                    child: ListTile(
                                      title: TextField(
                                        controller: selectedRadioTile == false ? TextEditingController() : TextEditingController(text:'Team ${index + 1}'),
                                        decoration: InputDecoration(
                                          hintText:"Enter Team Name",
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.0))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.0))),
                                          prefixIcon: Icon(Icons.group),
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                        ),

                                        onChanged: (val) =>
                                            _allTeamNames(val, index),
                                      ),
                                    ),
                                  ),
                                ));
                              })),
                    ),
              _test == 'notselected' ?
              Center(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                    child: Text(
                      'Please enter the team names',
                      style: TextStyle(
                          color: Colors.redAccent.shade700, fontSize: 16.0),
                    )),
              ) : _test == 'notall' ?
              Center(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                    child: Text(
                      'Please enter all the team names',
                      style: TextStyle(
                          color: Colors.redAccent.shade700, fontSize: 16.0),
                    )),
              ) : SizedBox(),
              _teams == '0'
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          color: Colors.transparent,
                        ),
                        child: CheckboxListTile(
                          activeColor: Colors.red[300],
                          title: Text('Give the individual team default name'),
                          value: selectedRadioTile,
                          subtitle: Text(
                              'Default name will be be given to all teams, for e.g team 1'),
                          onChanged: (val) {
                            setSelectedRadio(val);
                          },
                        ),
                      ),
                    ),
              SizedBox(height: 20.0),
              Container(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(19.0),
                  color: Colors.red,
                  child: Text(
                    'Generate Tie Sheet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  elevation: 0.0,
                  shape: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _saveIntoDatabase();
                    }
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
