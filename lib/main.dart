import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  String _time = '';
  AnimationController _controller;
  Animation<double> _tweenOpacity;
  Animation<double> _rotationTween;
  static TextStyle _style =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  Future<void> startTime() async {
    _controller.forward();
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _time = DateFormat('hh:mm:ss').format(DateTime.now());
        if (_controller.isCompleted)
          _controller.reverse();
        else if (_controller.isDismissed) _controller.forward();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    CurvedAnimation _curve =
        CurvedAnimation(curve: Curves.easeInOut, parent: _controller);
    _tweenOpacity = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0), weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1), weight: 50),
    ]).animate(_curve);
    _rotationTween = Tween<double>(begin: 0, end: 2 * pi).animate(_curve);

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The King"),
      ),
      body: Container(
        child: Center(
          child: _controller == null
              ? Text("loading")
              : AnimatedBuilder(
                  animation: _controller.view,
                  builder: (context, value) {
                    return Opacity(
                      child: Transform(
                        transform: Matrix4.rotationX(_rotationTween.value),
                        origin: Offset(0, 50),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "$_time",
                              style: _style,
                            ),
                          ),
                        ),
                      ),
                      opacity: _tweenOpacity.value,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
