import 'package:flutter/material.dart';
import 'package:tiesheet/league/league.dart';


class TieSheet extends StatefulWidget {
  final AppBar appBar;
  TieSheet({Key key, @required this.appBar}) : super(key: key);
  @override
  _TieSheetState createState() => _TieSheetState();
}

class _TieSheetState extends State<TieSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Tie Sheet')
      ),
      body:Center(
        child:Container(
          height: 1000.0,
          alignment: Alignment.centerLeft,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 50.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color:Colors.purpleAccent[100],
                              borderRadius: BorderRadius.all(Radius.circular(30.0))
                          ),
                          height: 100.0,
                          width: 100.0,
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration: BoxDecoration(
                              color:Colors.purpleAccent[100],
                              borderRadius: BorderRadius.all(Radius.circular(30.0))
                          ),
                          height: 100.0,
                          width: 100.0,
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration: BoxDecoration(
                              color:Colors.purpleAccent[100],
                              borderRadius: BorderRadius.all(Radius.circular(30.0))
                          ),
                          height: 100.0,
                          width: 100.0,
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration: BoxDecoration(
                              color:Colors.purpleAccent[100],
                              borderRadius: BorderRadius.all(Radius.circular(30.0))
                          ),
                          height: 100.0,
                          width: 100.0,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


