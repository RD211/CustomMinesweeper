import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'collision/Polygon.dart';
import 'models/MineSweeperBoard.dart';
import 'models/ShapeCreated.dart';
import 'screens/GameSelectorScreen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ShapeCreated()),
    ChangeNotifierProvider(
      create: (_) => MineSweeperBoard(difficulty: Difficulty.Easy, shapes: [
        Polygon.fromPoints(
          points: [
            Offset(49, 46),
            Offset(52, 48),
            Offset(50, 52),
            Offset(48, 52),
            Offset(46, 48),
          ],
        ),
        Polygon.fromPoints(
          points: [
            Offset(46, 46),
            Offset(52, 46),
            Offset(52, 52),
            Offset(46, 52),
          ],
        ),
        Polygon.fromPoints(
          points: [
            Offset(49, 46),
            Offset(46, 52),
            Offset(52, 52),
          ],
        ),
        Polygon.fromPoints(
          points: [
            Offset(49, 46),
            Offset(46, 52),
            Offset(52, 52),
          ],
        ),
      ]),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GameSelectorScreen(),
    );
  }
}
