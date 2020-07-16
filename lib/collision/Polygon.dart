
import 'package:flutter/cupertino.dart';

class Polygon
{
  List<Offset> points;
  Offset centroid;
  Polygon()
  {
    this.points = List<Offset>();
    this.centroid=Offset(0,0);
  }
  Polygon.fromPoints({@required this.points})
  {
    double sumX = 0;
    double sumY = 0;
    points.forEach((element) {sumX+=element.dx;sumY+=element.dy;});
    centroid = Offset(sumX/points.length,sumY/points.length);
  }
  


  static Polygon rotateAroundLine(Polygon poly, Offset a, Offset b)
  {
    List<Offset> newPoly = new List<Offset>();
    poly.points.forEach((c) {
      //Calc intermediary point
      var x1=a.dx, y1=a.dy, x2=b.dx, y2=b.dy, x3=c.dx, y3=c.dy;
      var px = x2-x1, py = y2-y1, dAB = px*px + py*py;
      var u = ((x3 - x1) * px + (y3 - y1) * py) / dAB;
      var x = x1 + u * px, y = y1 + u * py;
      Offset d = Offset(x,y);
      Offset slope = Offset(d.dx-c.dx,d.dy-c.dy);
      Offset newPoint = Offset(d.dx+slope.dx,d.dy+slope.dy);
      newPoly.add(newPoint);
    });
    return Polygon.fromPoints(points: newPoly);
  }

}
  extension DistanceD on Offset
  {
    double distanceD(Offset other)
    {
      return abs(this.dx-other.dx)+abs(this.dy-other.dy);
          }
      
        abs(double d) {
          if(d<0)
            return -d;
          return d;
        }
  }