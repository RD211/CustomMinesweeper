import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweep/models/MineSweeperBoard.dart';
import 'package:provider/provider.dart';

class BombWatcher extends StatefulWidget {
  const BombWatcher({
    Key key,
  }) : super(key: key);

  @override
  _BombWatcherState createState() => _BombWatcherState();
}

class _BombWatcherState extends State<BombWatcher> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = min(height * 0.8, width * 0.8);
    return Text(
      "Bombs left: ${Provider.of<MineSweeperBoard>(context).bombs - Provider.of<MineSweeperBoard>(context).warned}",
      style: TextStyle(
        color: Colors.redAccent,
        fontSize: size / 20,
      ),
    );
  }
}
