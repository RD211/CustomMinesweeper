import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:minesweep/collision/Polygon.dart';

class Collision {
  static bool doesOverlap(Polygon r1, Polygon r2) {
    var polys = [r1, r2];
    int poly1 = 0;
    int poly2 = 1;
    for (int shape = 0; shape < 2; shape++) {
      if (shape == 1) {
        poly1 = 1;
        poly2 = 0;
      }

      for (int a = 0; a < polys[poly1].points.length; a++) {
        int b = (a + 1) % polys[poly1].points.length;
        Offset axisProj = Offset(
            -(polys[poly1].points[b].dy - polys[poly1].points[a].dy),
            polys[poly1].points[b].dx - polys[poly1].points[a].dx);
        double d = sqrt(axisProj.dx * axisProj.dx + axisProj.dy * axisProj.dy);
        axisProj = Offset(axisProj.dx / d, axisProj.dy / d);

        double minR1 = double.infinity, maxR1 = double.negativeInfinity;
        for (int p = 0; p < polys[poly1].points.length; p++) {
          double q = (polys[poly1].points[p].dx * axisProj.dx +
              polys[poly1].points[p].dy * axisProj.dy);
          minR1 = min(minR1, q);
          maxR1 = max(maxR1, q);
        }
        double minR2 = double.infinity, maxR2 = double.negativeInfinity;
        for (int p = 0; p < polys[poly2].points.length; p++) {
          double q = (polys[poly2].points[p].dx * axisProj.dx +
              polys[poly2].points[p].dy * axisProj.dy);
          minR2 = min(minR2, q);
          maxR2 = max(maxR2, q);
        }

        if (!(maxR2 >= minR1 + 0.1 && maxR1 >= minR2 + 0.1)) return false;
      }
    }

    return true;
  }

  static bool isPointInPolygon(Polygon polygon, Offset testPoint) {
    bool result = false;
    int j = polygon.points.length - 1;
    for (int i = 0; i < polygon.points.length; i++) {
      if (polygon.points[i].dy < testPoint.dy &&
              polygon.points[j].dy >= testPoint.dy ||
          polygon.points[j].dy < testPoint.dy &&
              polygon.points[i].dy >= testPoint.dy) {
        if (polygon.points[i].dx +
                (testPoint.dy - polygon.points[i].dy) /
                    (polygon.points[j].dy - polygon.points[i].dy) *
                    (polygon.points[j].dx - polygon.points[i].dx) <
            testPoint.dx) {
          result = !result;
        }
      }
      j = i;
    }
    return result;
  }

  static bool _orientation(Offset a, Offset b, Offset c) {
    return (c.dy-a.dy) * (b.dx-a.dx) > (b.dy-a.dy) * (c.dx-a.dx);
  }

  static bool doesOverlap2(Polygon a, Polygon b) {
    //Check every point if its in the other poly
    a.points.forEach((element) {
      if (isPointInPolygon(b, element)) return true;
    });
    b.points.forEach((element) {
      if (isPointInPolygon(a, element)) return true;
    });
    //Check every line segment
    for (int i = 0; i < a.points.length; i++) {
      int j = (i + 1) % a.points.length;
      for (int ii = 0; ii < b.points.length; ii++) {
        int jj = (ii + 1) % b.points.length;
        var o1 = _orientation(a.points[i], b.points[ii], a.points[jj]);
        var o2 = _orientation(a.points[j], b.points[ii], b.points[jj]);
        var o3 = _orientation(a.points[i], b.points[j], a.points[ii]);
        var o4 = _orientation(a.points[i], b.points[j], a.points[jj]);

        // General case
        if (o1 != o2 && o3 != o4) return true;
      }
    }
    return false;
  }
}
