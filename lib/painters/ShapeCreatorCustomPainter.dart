import 'package:flutter/material.dart';
import 'package:minesweep/models/ShapeCreated.dart';
import 'package:provider/provider.dart';

class ShapeCreatorCustomPainter extends CustomPainter {
  bool _doRepaint = false;
  BuildContext context;
  ShapeCreatorCustomPainter({@required this.context}) {
    Provider.of<ShapeCreated>(context).addListener(() {
      _doRepaint = true;
    });
    _doRepaint = true;
  }
  @override
  void paint(Canvas canvas, Size size) {
    double widthCell = size.width / 10;
    double heightCell = size.height / 10;
    final fillBlueGrey = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blueGrey;
    final fillRed = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;
    for (int i = 0; i < 10; i++)
      canvas.drawLine(Offset(0, heightCell * i),
          Offset(size.width, heightCell * i), fillBlueGrey);
    for (int i = 0; i < 10; i++)
      canvas.drawLine(Offset(widthCell * i, 0),
          Offset(widthCell * i, size.height), fillBlueGrey);
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        canvas.drawCircle(
            Offset(widthCell * i, heightCell * j), 5, fillBlueGrey);
      }
    }
    var points = Provider.of<ShapeCreated>(context,listen: false).poly.points;
    for (int i = 0; i < points.length; i++) {
      int j = (i + 1) % points.length;
      canvas.drawLine(points[i].scale(widthCell, heightCell), points[j].scale(widthCell, heightCell), fillRed);
    }
  }

  @override
  bool shouldRepaint(ShapeCreatorCustomPainter oldDelegate) => _doRepaint;
}
