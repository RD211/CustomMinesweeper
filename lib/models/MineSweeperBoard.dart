import 'dart:collection';
import 'dart:math';

import 'package:collection/priority_queue.dart';
import 'package:flutter/material.dart';
import 'package:minesweep/collision/Collision.dart';
import 'package:minesweep/collision/Polygon.dart';
import 'package:minesweep/models/MineSweeperCell.dart';

enum Difficulty {
  Easy,
  Medium,
  Hard,
  Retarded,
}
enum GameState { Playing, Won, Lost }
var sizeForDifficulty = [100, 200, 300, 400];
var bombsForDifficulty = [1, 50, 75, 100];

class MineSweeperBoard with ChangeNotifier {
  int boardSize;
  int touched = 0;
  int warned = 0;
  int bombs = 0;
  DateTime started;
  String frozenScore;
  Difficulty difficulty = Difficulty.Medium;
  List<List<int>> graf;
  List<Polygon> shapes;
  List<MineSweeperCell> board;
  GameState state;
  MineSweeperBoard({@required this.difficulty, @required this.shapes}) {
    reset(difficulty);
  }
  void reset(Difficulty difficulty) {
    print("started setting up");
    _lineQueue = new Queue<List>();
    graf = new List<List<int>>();
    state = GameState.Playing;
    touched = 0;
    bombs = 0;
    warned = 0;
    started = null;
    this.boardSize = sizeForDifficulty[difficulty.index];
    this.difficulty = difficulty;
    _buildBoard2();
    _buildConnections2();
    _setBombs();
  }

  //Possible positions 100x100
  /*
  bool _placeCell(int x, int y) {
    Offset lastCellPos;
    if (x == 0) {
      if (y != 0)
        lastCellPos =
            (board[y - 1][boardSize - 1] as MineSweeperCell).polygon.points[0] -
                shapes[(board[y - 1][boardSize - 1] as MineSweeperCell)
                        .polygon
                        .type]
                    .points[0];
      else
        lastCellPos = new Offset(0, 0);
    } else {
      lastCellPos = (board[y][x - 1] as MineSweeperCell).polygon.points[0] -
          shapes[(board[y][x - 1] as MineSweeperCell).polygon.type].points[0];
    }
    for (int posY = lastCellPos.dy.floor(); posY < 100 - 6; posY++) {
      int start = 0;
      if (posY == lastCellPos.dy.floor()) start = lastCellPos.dx.floor();
      for (int posX = start; posX < 100 - 6; posX++) {
        for (int rotations = 0; rotations < 4; rotations++) {
          bool ok = true;
          List<Offset> tempPoints = List.from(shapes[rotations].points);
          for (int i = 0; i < tempPoints.length; i++) {
            tempPoints[i] =
                Offset(tempPoints[i].dx + posX, tempPoints[i].dy + posY);
          }
          var poly = Polygon.fromPoints(points: tempPoints, type: rotations);
          for (int cy = 0; cy <= y; cy++) {
            int ending = boardSize;
            if (cy == y) ending = x;
            for (int cx = 0; cx < ending; cx++) {
              if ((board[cy][cx] as MineSweeperCell).polygon !=
                  null) if ((board[cy][cx] as MineSweeperCell)
                      .polygon
                      .centroid
                      .distanceD(poly.centroid) <=
                  20) {
                if (Collision.doesOverlap(
                    (board[cy][cx] as MineSweeperCell).polygon, poly)) {
                  ok = false;
                }
              }
            }
          }
          if (ok) {
            (board[y][x] as MineSweeperCell).polygon = poly;
            return true;
          }
        }
      }
    }
    return false;
  }

  void _buildBoard() {
    board = List.generate(boardSize, (i) => List(boardSize), growable: false);
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        board[i][j] = new MineSweeperCell(type: MineSweeperCellType.Normal);
        if (!_placeCell(j, i)) {
          i = boardSize;
          j = boardSize;
          break;
        }
      }
    }
    notifyListeners();
  }
*/
  bool _isIntersectingAnyOtherPoly(Polygon poly, int id, int source) {
    for (int i = 0; i < id; i++) {
      if (source != i &&
          board[i].polygon.centroid.distanceD(poly.centroid) <= 12) {
        if (Collision.doesOverlap(poly, (board[i]).polygon)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _insideFrame(Polygon poly) {
    return poly.centroid.dx <= 100 &&
        poly.centroid.dx >= 0 &&
        poly.centroid.dy >= 0 &&
        poly.centroid.dy <= 100;
  }

  Queue<List> _lineQueue = new Queue<List>();
  bool _placeCell2(int id) {
    while (_lineQueue.isNotEmpty) {
      var line = _lineQueue.first;
      Polygon tryingThisPoly = Polygon.rotateAroundLine(
          board[line[0] as int].polygon, line[1], line[2]);
      if (!_isIntersectingAnyOtherPoly(tryingThisPoly, id, line[0] as int) &&
          _insideFrame(tryingThisPoly)) {
        board[id].polygon = tryingThisPoly;
        _lineQueue.removeFirst();
        for (int i = 0; i < tryingThisPoly.points.length; i++) {
          int j = (i + 1) % tryingThisPoly.points.length;
          _lineQueue.add([id, tryingThisPoly.points[i], tryingThisPoly.points[j]]);
        }
        return true;
      }
      _lineQueue.removeFirst();
    }

    return false;
  }

  void _buildBoard2() {
    board = List<MineSweeperCell>();
    for (int i = 0; i < boardSize; i++) {
      board.add(new MineSweeperCell(type: MineSweeperCellType.Normal));
      graf.add(new List<int>());
      if (i == 0) {
        board[i].polygon = shapes[Random().nextInt(shapes.length)];
        for (int j = 0; j < board[i].polygon.points.length; j++) {
          int k = (j + 1) % board[i].polygon.points.length;
          _lineQueue.add([0, board[i].polygon.points[j], board[i].polygon.points[k]]);
        }
      } else if (!_placeCell2(i)) {
        board.removeLast();
        graf.removeLast();
        break;
      }
    }
    notifyListeners();
  }

  void _buildConnections2() {
    for (int i = 0; i < board.length; i++) {
      for (int j = i + 1; j < board.length; j++) {
        var firstPoly = board[i].polygon;
        var secondPoly = board[j].polygon;
        bool ok = false;
        firstPoly.points.forEach((element1) {
          secondPoly.points.forEach((element2) {
            if (element1.distanceD(element2) <= 1) {
              ok = true;
            }
          });
        });
        if (ok) {
          graf[i].add(j);
          graf[j].add(i);
        }
      }
    }
  }

  void _setBombs() {
    bombs = bombsForDifficulty[difficulty.index];
    for (int i = 0; i < bombs; i++) {
      int j = Random().nextInt(board.length - 1);
      if (board[j].type == MineSweeperCellType.Bomb) {
        i--;
      } else {
        board[j].type = MineSweeperCellType.Bomb;
        graf[j].forEach((element) {
          board[element].neighbours++;
        });
      }
    }
    notifyListeners();
  }

/*
  void _buildConnections() {
    var cues = new List<List<HeapPriorityQueue<dynamic>>>();
    for (int i = 0; i < boardSize; i++) {
      cues.add(new List<HeapPriorityQueue<dynamic>>());
      for (int j = 0; j < boardSize; j++) {
        for (int ii = 0; ii <= i; ii++) {
          cues[i].add(new HeapPriorityQueue((x, y) {
            if ((x[0] as double) <= (y[0] as double)) return -1;
            return 1;
          }));
          for (int jj = 0; jj < (ii == i ? j : boardSize); jj++) {
            double dist = (board[ii][jj] as MineSweeperCell)
                .polygon
                .centroid
                .distanceD((board[i][j] as MineSweeperCell).polygon.centroid);
            cues[i][j].add([dist, ii, jj]);
            cues[ii][jj].add([dist, i, j]);
          }
        }
      }
    }
    for (int i = 0; i < boardSize; i++) {
      graf.add(new List<List<Point>>());
      for (int j = 0; j < boardSize; j++) {
        int times = 6;
        graf[i].add(new List<Point>());
        while (times-- > 0) {
          var r = cues[i][j].first;
          graf[i][j].add(Point(r[2], r[1]));
          cues[i][j].removeFirst();
        }
      }
    }
  }
*/
  List<bool> _vizBoard;
  void _recursiveOpening(int id) {
    if (board[id].type == MineSweeperCellType.Bomb) return;
    if (touched + bombs == board.length) {
      _winGame();
    }
    if (_vizBoard[id]) {
      return;
    }
    touched++;
    _vizBoard[id] = true;
    board[id].setVisible();
    if (board[id].neighbours == 0) {
      graf[id].forEach((element) {
        _recursiveOpening(element);
      });
    }
  }

  void _winGame() {
    state = GameState.Won;
    frozenScore =
        '${DateTime.now().difference(started).inMinutes.toString().padLeft(2, '0')}:${DateTime.now().difference(started).inSeconds.toString().padLeft(2, '0')}';
  }

  void _loseGame() {
    state = GameState.Lost;
    frozenScore =
        '${DateTime.now().difference(started).inMinutes.toString().padLeft(2, '0')}:${DateTime.now().difference(started).inSeconds.toString().padLeft(2, '0')}';
  }

  void handleMark(LongPressStartDetails details, double width,double height) {
    if (started == null) started = DateTime.now();
    if (state != GameState.Playing) {
      reset(difficulty);
      return;
    }
    var sizeDiff = (min(height,width) / 100);
    double widthAdder = 0 ;
    double heightAdder = 0;
    if(height>width)
    {
      heightAdder=(height-sizeDiff*100)/2;
    }
    else
    {
      widthAdder=(width-sizeDiff*100)/2;
    }
    var xCoord = (details.localPosition.dx-widthAdder) / sizeDiff;
    var yCoord = (details.localPosition.dy-heightAdder) / sizeDiff;
    int index = -1;
    for (int i = 0; i < board.length; i++) {
      if (board[i].polygon.points.length > 0) {
        if (Collision.isPointInPolygon(
            board[i].polygon, Offset(xCoord, yCoord))) {
          index = i;
          break;
        }
      }
    }
    if (index == -1) return;
    if (board[index].state == MineSweeperCellState.Hidden) {
      board[index].state = MineSweeperCellState.Marked;
      warned++;
    } else if (board[index].state == MineSweeperCellState.Marked) {
      board[index].state = MineSweeperCellState.Hidden;
      warned--;
    }
    notifyListeners();
  }

  void handleClick(TapUpDetails details, double width, double height) {
    if (started == null) started = DateTime.now();
    if (state != GameState.Playing) {
      reset(difficulty);
      return;
    }
        var sizeDiff = (min(height,width) / 100);
    double widthAdder = 0 ;
    double heightAdder = 0;
    if(height>width)
    {
      heightAdder=(height-sizeDiff*100)/2;
    }
    else
    {
      widthAdder=(width-sizeDiff*100)/2;
    }
    var xCoord = (details.localPosition.dx-widthAdder) / sizeDiff;
    var yCoord = (details.localPosition.dy-heightAdder) / sizeDiff;
    int index = -1;
    for (int i = 0; i < board.length; i++) {
      if (Collision.isPointInPolygon(
          board[i].polygon, Offset(xCoord, yCoord))) {
        index = i;
        break;
      }
    }
    if (index == -1) return;

    if (board[index].state != MineSweeperCellState.Hidden) {
      return;
    }

    board[index].setVisible();
    if (board[index].type == MineSweeperCellType.Bomb) {
      _loseGame();
    } else if (board[index].neighbours == 0) {
      _vizBoard = List<bool>();
      for (int i = 0; i < board.length; i++) _vizBoard.add(false);
      _recursiveOpening(index);
    } else {
      touched++;
      if (touched + bombs == board.length) {
        _winGame();
      }
    }
    notifyListeners();
  }
}
