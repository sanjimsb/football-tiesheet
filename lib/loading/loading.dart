import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tiesheet/home/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  void _navigateToHome() async{
    await Future.delayed(Duration(seconds: 3),(){});
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>HomePageAppbar()));
  }

  @override
  void initState() {
    _navigateToHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
            child:Opacity(
              opacity: 0.8,
              child: Image.asset('assets/images/football-ts.png'),
            )),
            Padding(
              padding:EdgeInsets.fromLTRB(0, 200.0, 0, 0),
                child:Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.blue,
                    child:Container(
                      child: Text(
                          'Football League Generator',
                          style: TextStyle(
                            fontSize: 25.0,
                          )
                      ),
                    )
                )
            )

          ],
        ),
      ),
    );
  }
}
