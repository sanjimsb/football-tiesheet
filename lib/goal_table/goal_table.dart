import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:tiesheet/tiesheet_database/tiesheet_database.dart';

class GoalTable extends StatefulWidget {
  final String value;

  GoalTable({Key key, @required this.value}) : super(key: key);

  @override
  _GoalTableState createState() => _GoalTableState();
}

class _GoalTableState extends State<GoalTable> {
  int _defaultValue = 0;
  int _counter = 0;
  List allTeams = [];
  String _selectedTeamName = '';
  String _playerName = '';
  int _numberOfGoalScored = 0;
  bool _teamNameSelected = false;
  List<GoalDetails> _goalScoredDetails = [];
  var myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _getTeamNames() async {
    await MatchDetails.db.getGoalScored(widget.value).then((goalScoredDetails) {
      setState(() {
        _goalScoredDetails = goalScoredDetails;
      });
    });
    await MatchDetails.db.getMatch(widget.value).then((matchInfo) {
      for (var i = 0; i < matchInfo.length; i++) {
        allTeams.add(matchInfo[i].teamName);
      }
    });
  }

  void _saveNumberOfGoals(val) {
    setState(() {
      _numberOfGoalScored = val;
    });
  }

  void _saveTeamName(val) {
    setState(() {
      _selectedTeamName = val;
    });
  }

  void _updatePlayerName(val) {
    setState(() {
      _playerName = val;
    });
  }

  void _helperFunctionSave() async {
    if (_selectedTeamName == '') {
      _teamNameSelected = true;
      return;
    }
    String pn = _playerName;
    String tn = _selectedTeamName;
    String mn = widget.value;
    int gn = _numberOfGoalScored;
    GoalDetails updateGoals;

    await MatchDetails.db
        .updateGoalScoredByIndividual(mn, tn, pn)
        .then((goalScoreByPlayer) {
      if (goalScoreByPlayer.isEmpty) return;
      updateGoals = GoalDetails(
          playerName: pn, matchName: mn, teamName: tn, numberOfGoals: gn);
    });
    GoalDetails goals = GoalDetails(
        playerName: pn, matchName: mn, teamName: tn, numberOfGoals: gn);
    if (updateGoals != null) {
      await MatchDetails.db.updateGoalScoredByIndividualPlayer(updateGoals);
    } else {
      await MatchDetails.db.insertGoalScored(goals);
    }
    await MatchDetails.db.getGoalScored(widget.value).then((goalScoredDetails) {
      setState(() {
        _goalScoredDetails = goalScoredDetails;
      });
      _selectedTeamName = '';
      _playerName = '';
      _numberOfGoalScored = 0;
      _defaultValue = 0;
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _getTeamNames();
    super.initState();
  }

  String _capitalizeFirstString(val) {
    return (val.toUpperCase()[0]);
  }

  void _saveGoalScored() {
    setState(() {
      _teamNameSelected = false;
      _helperFunctionSave();
    });
  }

  void showSettingsPanel(index, val) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Form(
                key: _formKey,
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
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 0.0),
                      child: TextFormField(
                        controller: myController,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                          hintText: "Player Name",
                          prefixIcon: Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                        validator: (val) {
                          if (val == '')
                            return 'Please enter the Player Name';
                          else
                            return null;
                        },
                        onChanged: (val) {
                          setModalState(() {
                            _updatePlayerName(val);
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
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
                            hint: Text('Team Name'),
                            value: (index != null && val != null)
                                ? val[index].teamName
                                : _selectedTeamName == ''
                                    ? null
                                    : _selectedTeamName,
                            isExpanded: true,
                            items: allTeams.map((value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            onChanged: (val) {
                              _selectedTeamName = val;
                              setModalState(() {
                                _saveTeamName(val);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    _teamNameSelected == true
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(28.0, 8.0, 18.0, 0.0),
                            child: Text(
                              'Choose the team name',
                              style: TextStyle(
                                  color: Colors.redAccent.shade700,
                                  fontSize: 16.0),
                            ))
                        : SizedBox(),
                    SizedBox(height: 10.0),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 18.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Center(
                                  child: Text(
                                    'Goal Scored: ',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                )),
                                Expanded(
                                    child: Center(
                                        child: Counter(
                                  initialValue: _defaultValue,
                                  minValue: 0,
                                  maxValue: 200,
                                  step: 1,
                                  decimalPlaces: 0,
                                  buttonSize: 40,
                                  textStyle: TextStyle(fontSize: 40.0),
                                  onChanged: (value) {
                                    setModalState(() {
                                      _defaultValue = value;
                                      _counter = value;
                                      _saveNumberOfGoals(value);
                                    });
                                  },
                                )))
                              ],
                            )
                          ],
                        )),
                    SizedBox(height: 10.0),
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
                              if (_formKey.currentState.validate()) {
                                _saveGoalScored();
                              }
                            });
                          }),
                    )),
                  ],
                ),
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
        title: Text('Goal Details'),
      ),
      body: Container(
        child:ListView.builder(
                itemCount: _goalScoredDetails.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[800],
                        child: Text(_capitalizeFirstString(
                            _goalScoredDetails[index].playerName)),
                        foregroundColor: Colors.white,
                      ),
                      title: Text('${_goalScoredDetails[index].playerName}'),
                      subtitle: Text('${_goalScoredDetails[index].teamName}'),
                      trailing: Text(
                          '${_goalScoredDetails[index].numberOfGoals} goals'),
                      onTap: () {
                        myController = TextEditingController(
                            text: _goalScoredDetails[index].playerName);
                        setState(() {
                          _playerName = _goalScoredDetails[index].playerName;
                          _defaultValue =
                              _goalScoredDetails[index].numberOfGoals;
                          _numberOfGoalScored =
                              _goalScoredDetails[index].numberOfGoals;
                          _selectedTeamName =
                              _goalScoredDetails[index].teamName;
                        });
                        showSettingsPanel(index, _goalScoredDetails);
                      },
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myController = TextEditingController();
          _defaultValue = 0;
          _selectedTeamName = '';
          showSettingsPanel(null, null);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[800],
      ),
    );
  }
}
