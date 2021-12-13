import 'package:flutter/material.dart';
import 'package:tiesheet/tiesheet_database/tiesheet_database.dart';
import 'package:tiesheet/matchtable/matchtable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MatchList extends StatefulWidget {
  @override
  _MatchListState createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  List<AllMatches> _allMatchesList = [];

  void _getAllMatches() async {
    await MatchDetails.db.getAllMatches().then((matches) {
      setState(() => _allMatchesList = matches);
    });
  }

  void _deleteMatch(val) async {
    await MatchDetails.db.deleteMatchDetails(val);
    setState(() {
      _getAllMatches();
    });
    Navigator.pop(context);
  }

  void _doNotDeleteMatch() {
    Navigator.pop(context);
  }

  String _capitalizeFirstString(val) {
    return (val.toUpperCase()[0]);
  }

  void _showMatchDetails(val) {
    var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
            LinkMatchTableAndMatches(value: val));
    Navigator.of(context).push(route);
  }

  @override
  void initState() {
    _getAllMatches();
    super.initState();
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  void showSettingsPanel(val, index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 200.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      child: Text(
                        'Do yo really want to delete?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(height: 20.0),
                  Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                            child: RaisedButton(
                                color: Colors.red,
                                padding: EdgeInsets.all(19.0),
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                elevation: 0.0,
                                shape: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                onPressed: () {
                                  setModalState(() {
                                    _deleteMatch(val);
                                  });
                                }),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                              child: RaisedButton(
                                padding: EdgeInsets.all(19.0),
                                color: Colors.red,
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                elevation: 0.0,
                                shape: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                onPressed: () => _doNotDeleteMatch(),
                              )),
                        )
                      ],
                    ),
                  ])
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
        title: Text('Match List'),
      ),
      body: Container(
        child: ListView.builder(
                itemCount: _allMatchesList.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[800],
                          child: Text(_capitalizeFirstString(
                              _allMatchesList[index].matchName)),
                          foregroundColor: Colors.white,
                        ),
                        title: Text(_allMatchesList[index].matchName),
                        subtitle: Text(
                            'Includes ${_allMatchesList[index].numberOfTeams} Teams.'),
                        onTap: () =>
                            _showMatchDetails(_allMatchesList[index].matchName),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => showSettingsPanel(
                            _allMatchesList[index].matchName, index),
                      ),
                    ],
                  );
//              return Dismissible(
//                background: stackBehindDismiss(),
//                  key: ObjectKey(_allMatchesList[index]),
//                  child: Container(
//                    padding: EdgeInsets.all(20.0),
//                    child: Text(_allMatchesList[index].matchName),
//                  ));
//              return ListTile(
//                title: Text(_allMatchesList[index].matchName),
//                onTap: () =>
//                    _showMatchDetails(_allMatchesList[index].matchName),
//              );
                }),
      ),
    );
  }
}
