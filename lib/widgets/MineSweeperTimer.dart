import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweep/models/MineSweeperBoard.dart';
import 'package:provider/provider.dart';

class MineSweeperTimer extends StatefulWidget {
  MineSweeperTimer({Key key}) : super(key: key);

  @override
  _MineSweeperTimerState createState() => _MineSweeperTimerState();
}

class _MineSweeperTimerState extends State<MineSweeperTimer> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = min(height * 0.8, width * 0.8);
    var start = Provider.of<MineSweeperBoard>(context).started;

    return Container(
      height: height * 0.05,
      child: Text(
        start != null
            ? "Time: ${(DateTime.now().difference(start).inMinutes%60).toString().padLeft(2, '0')}:${(DateTime.now().difference(start).inSeconds%60).toString().padLeft(2, '0')}"
            : "Time: 00:00",
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: size / 20,
        ),
      ),
    );
  }
}
