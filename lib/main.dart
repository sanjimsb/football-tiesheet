import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiesheet/home/home.dart';
import 'package:tiesheet/league/league.dart';
import 'package:tiesheet/tiesheet/tiesheet.dart';
import 'package:tiesheet/leader_board/leaderboard.dart';
import 'package:tiesheet/match_lists/match_list.dart';
import 'package:tiesheet/loading/loading.dart';

import 'matchtable/matchtable.dart';
import 'package:flutter/services.dart';

void main(context) => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
//    return League();
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context) => SplashScreen(),
        '/home': (context) => HomePageAppbar(),
        '/matchlist': (context) => MatchList(),
        '/league': (context) => League(),
        '/tiesheet': (context) => TieSheet(),
        '/matchtable': (context) => MatchTable(),
      },
      theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          ),
          accentColor: Colors.grey[800]),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return TypeOfTieSheet();
  }
}
