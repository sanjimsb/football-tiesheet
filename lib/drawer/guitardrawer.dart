import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomGuitarDrawer extends StatefulWidget {
  final Widget child;

  const CustomGuitarDrawer({Key key, this.child}) : super(key: key);

  static CustomGuitarDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<CustomGuitarDrawerState>();

  @override
  CustomGuitarDrawerState createState() => new CustomGuitarDrawerState();
}

class CustomGuitarDrawerState extends State<CustomGuitarDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggle() =>
      animationController.isDismissed
          ? animationController.forward()
          : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.translucent,
//      onTap: toggle,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Material(
            color: Colors.blueGrey,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(maxSlide * (animationController.value - 1), 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(math.pi / 2 * (1 - animationController.value)),
                    alignment: Alignment.centerRight,
                    child: MyDrawer(),
                  ),
                ),
                Transform.translate(
                  offset: Offset(maxSlide * animationController.value, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-math.pi * animationController.value / 2),
                    alignment: Alignment.centerLeft,
                    child: widget.child,
                  ),
                ),
                Positioned(
                  top: 4.0 + MediaQuery
                      .of(context)
                      .padding
                      .top,
                  left: 4.0 + animationController.value * maxSlide,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: toggle,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery
              .of(context)
              .size
              .width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _onHome() {
      Navigator.pushReplacementNamed(context, '/home');
    }
    void _onMatchTable() {
      Navigator.pushNamed(context, '/matchlist');
    }
    return SizedBox(
      width: 300,
      height: double.infinity,
      child: Material(
        color: Colors.grey[800],
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: _onHome,
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.table),
                  title: Text('Match Lists'),
                  onTap: _onMatchTable,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}