import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tiesheet/tiesheet_database/tiesheet_database.dart';

class LeaderBoard extends StatefulWidget {
  final String value;

  LeaderBoard({Key key, @required this.value}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  List _matchResult = [];

  void _getTheTable() async {
    await MatchDetails.db.getLeaderBoardDetails(widget.value).then((goalList) {
      for (var i = 0; i < goalList.length; i++) {
        _matchResult.add({
          "teamName": goalList[i].teamNameHome,
          "played": goalList[i].played,
          "win": goalList[i].win,
          "draw": goalList[i].draw,
          "loss": goalList[i].loss,
          "goalDifference": goalList[i].goalDifference,
          "points": goalList[i].points
        });
      }
    });

    setState(() {
      for (var i = 0; i < _matchResult.length - 1; i++) {
        for (var j = i + 1; j < _matchResult.length; j++) {
          if (_matchResult[i]["teamName"] == _matchResult[j]["teamName"]) {
            _matchResult[i] = {
              "teamName": _matchResult[i]["teamName"],
              "played": _matchResult[i]["played"] + _matchResult[j]["played"],
              "win": _matchResult[i]["win"] + _matchResult[j]["win"],
              "draw": _matchResult[i]["draw"] + _matchResult[j]["draw"],
              "loss": _matchResult[i]["loss"] + _matchResult[j]["loss"],
              "goalDifference": _matchResult[i]["goalDifference"] +
                  _matchResult[j]["goalDifference"],
              "points": _matchResult[i]["points"] + _matchResult[j]["points"]
            };
            _matchResult.removeAt(j);
            i = 0;
          }
        }
      }
      for (var i = 0; i < _matchResult.length - 1; i++) {
        if (_matchResult[i]["points"] > _matchResult[i + 1]["points"]) {
          var temp = {
            "teamName": _matchResult[i]["teamName"],
            "played": _matchResult[i]["played"],
            "win": _matchResult[i]["win"],
            "draw": _matchResult[i]["draw"],
            "loss": _matchResult[i]["loss"],
            "goalDifference": _matchResult[i]["goalDifference"],
            "points": _matchResult[i]["points"]
          };
          _matchResult[i] = _matchResult[i + 1];
          _matchResult[i + 1] = temp;
          i = -1;
        }
      }

      for (var i = 0; i < _matchResult.length; i++) {
        _matchResult[i] = {
          "pos": _matchResult.length - i,
          "teamName": _matchResult[i]["teamName"],
          "played": _matchResult[i]["played"],
          "win": _matchResult[i]["win"],
          "draw": _matchResult[i]["draw"],
          "loss": _matchResult[i]["loss"],
          "goalDifference": _matchResult[i]["goalDifference"],
          "points": _matchResult[i]["points"]
        };
      }
    });
  }

  @override
  void initState() {
    _getTheTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text('Leader Board'),
//        elevation: 0.0,
      ),
      body: _matchResult.length == 0
          ? SpinKitFadingCube(
              color: Colors.black26,
              size: 100.0,
            )
          : Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 28.0,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text('Pos'),
                      ),
                      DataColumn(
                        label: Text('Team Name'),
                      ),
                      DataColumn(
                        label: Text('PL'),
                      ),
                      DataColumn(
                        label: Text('W'),
                      ),
                      DataColumn(
                        label: Text('D'),
                      ),
                      DataColumn(
                        label: Text('L'),
                      ),
                      DataColumn(
                        label: Text('GD'),
                      ),
                      DataColumn(
                        label: Text('Pts'),
                      )
                    ],
                    rows: _matchResult.reversed
                        .map(
                          (element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(element["pos"].toString())),
                              DataCell(Row(
                                children: <Widget>[
                                  Text(element["teamName"]),
                                  element["pos"].toString() == '1'
                                      ? Icon(
                                          MdiIcons.trophy,
                                          color: Colors.deepOrange,
                                        )
                                      : SizedBox(),
                                ],
                              )),
                              DataCell(Text(element["played"].toString())),
                              DataCell(Text(element["win"].toString())),
                              DataCell(Text(element["draw"].toString())),
                              DataCell(Text(element["loss"].toString())),
                              DataCell(
                                  Text(element["goalDifference"].toString())),
                              DataCell(Text(element["points"].toString())),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              )),
    );
  }
}
