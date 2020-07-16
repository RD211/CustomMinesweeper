import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweep/screens/MineSweeperScreen.dart';
import 'package:minesweep/screens/ShapeCreatorScreen.dart';

class GameSelectorScreen extends StatefulWidget {
  @override
  _GameSelectorScreenState createState() => _GameSelectorScreenState();
}

class _GameSelectorScreenState extends State<GameSelectorScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          width: min(width*0.8, 700.0),
          height: min(height*0.7, 700.0),
          child: ListView(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return MineSweeperScreen();
                  },));
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(255, 223, 64, 1),
                          Color.fromRGBO(255, 131, 89, 1),
                        ],
                      ),
                      border: Border.all(width: 0,color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          offset: Offset(0.0, 2.5),
                          blurRadius: 2.5,
                        ),
                      ]),
                  child: ListTile(
                    leading: Container(
                      width: width*0.1,
                      child: Icon(
                        Icons.games,
                        size: height / 20,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "MineSweeper",
                      style: TextStyle(fontSize: height / 15,color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return ShapeCreatorScreen();
                  },));
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(255, 223, 64, 1),
                          Color.fromRGBO(255, 131, 89, 1),
                        ],
                      ),
                      border: Border.all(width: 0,color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          offset: Offset(0.0, 2.5),
                          blurRadius: 2.5,
                        ),
                      ]),
                  child: ListTile(
                    leading: Container(
                      width: width*0.1,
                      child: Icon(
                        Icons.create,
                        size: height / 20,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "Shape creator",
                      style: TextStyle(fontSize: height / 15,color: Colors.white),
                    ),
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
