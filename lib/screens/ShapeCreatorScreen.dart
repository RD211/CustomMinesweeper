import 'package:flutter/material.dart';
import 'package:minesweep/models/MineSweeperBoard.dart';
import 'package:minesweep/models/ShapeCreated.dart';
import 'package:minesweep/painters/ShapeCreatorCustomPainter.dart';
import 'package:provider/provider.dart';

class ShapeCreatorScreen extends StatefulWidget {
  ShapeCreatorScreen({Key key}) : super(key: key);

  @override
  _ShapeCreatorScreenState createState() => _ShapeCreatorScreenState();
}

class _ShapeCreatorScreenState extends State<ShapeCreatorScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          GestureDetector(
            onTapUp: (details) =>
                Provider.of<ShapeCreated>(context, listen: false).addPoint(
                    Offset(details.localPosition.dx / (width / 10),
                        details.localPosition.dy / (height / 10))),
            child: Container(
              width: width,
              height: height,
              child: CustomPaint(
                painter: ShapeCreatorCustomPainter(context: context),
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
                  FlatButton.icon(
                    onPressed: () {
                      Provider.of<ShapeCreated>(context, listen: false)
                          .popPoint();
                    },
                    icon: Icon(Icons.undo),
                    label: Text(
                      "Undo",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.orangeAccent,
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Provider.of<MineSweeperBoard>(context, listen: false)
                          .shapes
                          .add(Provider.of<ShapeCreated>(context, listen: false)
                              .export());
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.orangeAccent,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
