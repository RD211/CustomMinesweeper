import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweep/models/MineSweeperBoard.dart';
import 'package:minesweep/painters/MineSweeperCustomPainter.dart';
import 'package:minesweep/widgets/BombWatcher.dart';
import 'package:minesweep/widgets/DifficultyButton.dart';
import 'package:minesweep/widgets/MineSweeperTimer.dart';
import 'package:provider/provider.dart';

class MineSweeperScreen extends StatefulWidget {
  @override
  _MineSweeperScreenState createState() => _MineSweeperScreenState();
}

class _MineSweeperScreenState extends State<MineSweeperScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = min(height, width);

    return Scaffold(
      body: Center(
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              GestureDetector(
                onTapUp: (details) =>
                    Provider.of<MineSweeperBoard>(context, listen: false)
                        .handleClick(details, width,height),
                onLongPressStart: (details) =>
                    Provider.of<MineSweeperBoard>(context, listen: false)
                        .handleMark(details, width,height),
                child: Container(
                  width: width,
                  height: height,
                  child: CustomPaint(
                    painter: MineSweeperCustomPainter(context: context),
                  ),
                ),
              ),
              Positioned(
                top: height * 0.05,
                width: width,
                child: Container(
                  height: height * 0.05,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BombWatcher(),
                      MineSweeperTimer(),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: height*0.05,
                width: width,
                child: Container(
                  width: size,
                  height: height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DifficultyButton(
                          difficulty: Difficulty.Easy, color: Colors.greenAccent),
                      DifficultyButton(
                          difficulty: Difficulty.Medium,
                          color: Colors.orangeAccent),
                      DifficultyButton(
                          difficulty: Difficulty.Hard, color: Colors.redAccent),
                      DifficultyButton(
                          difficulty: Difficulty.Retarded, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
