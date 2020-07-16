import 'package:flutter/cupertino.dart';
import 'package:minesweep/collision/Polygon.dart';

class ShapeCreated with ChangeNotifier {
  Polygon poly;
  ShapeCreated() {
    this.poly = new Polygon();
  }
  void addPoint(Offset point) {
    poly.points.add(point);
    notifyListeners();
  }

  void popPoint() {
    if (poly.points.length > 0) poly.points.removeLast();
    notifyListeners();
  }

  Polygon export() {
    List<Offset> points = new List<Offset>();
    poly.points.forEach((element) {
      points.add(element + Offset(46, 46));
    });
    return Polygon.fromPoints(points: points);
  }
}
