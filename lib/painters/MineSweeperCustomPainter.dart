import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweep/models/MineSweeperBoard.dart';
import 'package:minesweep/models/MineSweeperCell.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class MineSweeperCustomPainter extends CustomPainter {
  bool _doRepaint = false;
  BuildContext context;
  MineSweeperCustomPainter({@required this.context}) {
    Provider.of<MineSweeperBoard>(context).addListener(() {
      _doRepaint = true;
    });
    _doRepaint = true;
  }
  @override
  void paint(Canvas canvas, Size size) {
    var gameObject = Provider.of<MineSweeperBoard>(context, listen: false);
    var sizeDiff = (min(size.height,size.width) / 100);
    double widthAdder = 0 ;
    double heightAdder = 0;
    if(size.height>size.width)
    {
      heightAdder=(size.height-sizeDiff*100)/2;
    }
    else
    {
      widthAdder=(size.width-sizeDiff*100)/2;
    }
    if (gameObject.state == GameState.Won) {
      TextSpan span = new TextSpan(
        text: 'You won!\n${gameObject.frozenScore} ',
        style: TextStyle(
          color: Colors.green,
          fontSize: min(size.width,size.height) / 8.5 / 5,
        ),
      );
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, new Offset(min(size.width,size.height) / 8.5, min(size.width,size.height) / 8.5 / 4));
      return;
    } else if (gameObject.state == GameState.Lost) {
      TextSpan span = new TextSpan(
        text: 'You lost!',
        style: TextStyle(
          color: Colors.red,
          fontSize: min(size.width,size.height) / 8.5 / 5,
        ),
      );
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, new Offset(min(size.width,size.height) / 8.5 / 8.5, min(size.width,size.height) / 8.5 / 4));
      return;
    }
    final fillGrey = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey;
    final fillYellow = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.yellow;
    final fillGreen = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green;
    final gradient = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        <Color>[
          Color.fromRGBO(255, 223, 64, 1),
          Color.fromRGBO(255, 131, 89, 1),
        ],
      );
    canvas.drawRect(
        Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
        gradient);
    for (int index = 0; index < gameObject.board.length; index++) {
      switch (gameObject.board[index].state) {
        case MineSweeperCellState.Visible:
          var neighbours = gameObject.board[index].neighbours;
          TextSpan span = new TextSpan(
            text: '$neighbours',
            style: TextStyle(
              color: Color.fromRGBO(
                  min(255, (255 / 5 * neighbours).floor()), 0, 0, 1),
              fontSize: min(size.width,size.height) / 25,
            ),
          );
          TextPainter tp = new TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr);
          tp.layout();
          canvas.drawPath(
              Path()
                ..addPolygon(
                    gameObject.board[index].polygon.points
                        .map((e) => Offset(e.dx * sizeDiff + widthAdder, e.dy * sizeDiff + heightAdder))
                        .toList(),
                    true),
              fillGreen);
          if (neighbours > 0)
            tp.paint(
                canvas,
                (gameObject.board[index].polygon.centroid - Offset(3, 3)) *
                    sizeDiff + Offset(widthAdder,heightAdder));

          break;
        case MineSweeperCellState.Hidden:
          canvas.drawPath(
              Path()
                ..addPolygon(
                    gameObject.board[index].polygon.points
                        .map((e) => Offset(e.dx * sizeDiff, e.dy * sizeDiff)+ Offset(widthAdder,heightAdder))
                        .toList(),
                    true),fillGrey);
          break;
        case MineSweeperCellState.Marked:
          canvas.drawPath(
              Path()
                ..addPolygon(
                    gameObject.board[index].polygon.points
                        .map((e) => Offset(e.dx * sizeDiff, e.dy * sizeDiff)+ Offset(widthAdder,heightAdder))
                        .toList(),
                    true),
              fillYellow);

          break;
      }

      _doRepaint = false;
    }
  }

  @override
  bool shouldRepaint(MineSweeperCustomPainter oldDelegate) => _doRepaint;
}
