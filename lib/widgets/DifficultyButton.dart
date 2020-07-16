import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minesweep/models/MineSweeperBoard.dart';
import 'package:provider/provider.dart';

class DifficultyButton extends StatelessWidget {
  final Difficulty difficulty;
  final Color color;
  DifficultyButton({@required this.difficulty, @required this.color});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = min(height * 0.8, width * 0.8);
    return Container(
      width: size*0.2,
      height: size*0.1,
      child: Card(
        child: RaisedButton(
          onPressed: () {
            Provider.of<MineSweeperBoard>(context, listen: false)
                .reset(difficulty);
          },
          color: color,
          child: Text(
            describeEnum(difficulty),
            style: TextStyle(
              color: Colors.white,
              fontSize: size / 30,
            ),
          ),
        ),
      ),
    );
  }
}
