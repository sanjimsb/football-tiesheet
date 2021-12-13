import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tiesheet/drawer/drawer.dart';
import 'package:tiesheet/drawer/guitardrawer.dart';

class HomePageAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool flip = false;
    AppBar appBar = flip
        ? AppBar()
        : AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => CustomDrawer.of(context).open(),
                );
              },
            ),
            title: Text('League Match'),
            backgroundColor: Colors.grey[800],
          );

    Widget child = TypeOfTieSheet(appBar: appBar);
    if (flip) {
      child = CustomGuitarDrawer(child: child);
    } else {
      child = CustomGuitarDrawer(child: child);
    }
    return child;
  }
}

class TypeOfTieSheet extends StatelessWidget {
  final AppBar appBar;

  TypeOfTieSheet({Key key, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goToLeague() {
      Navigator.pushNamed(context, '/league');
    }

    return Scaffold(
//      key:scaffoldKey,
      appBar: appBar,

      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onTap: _goToLeague,
                  child: ListTile(
                    contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
                    leading: Icon(
                      FontAwesomeIcons.sitemap,
                      size: 35.0,
                      color: Colors.grey[800],
                    ),
                    title: Text('League Match',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle: Text('Generate the match table and league table'),
                    isThreeLine: true,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
