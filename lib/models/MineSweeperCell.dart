import 'package:minesweep/collision/Polygon.dart';

enum MineSweeperCellType
{
  Normal,
  Bomb
}

enum MineSweeperCellState
{
  Hidden,
  Visible,
  Marked
}

class MineSweeperCell
{
  MineSweeperCellState state = MineSweeperCellState.Hidden;
  MineSweeperCellType type;
  Polygon polygon = Polygon();
  int neighbours=0;
  MineSweeperCell({this.type});
  void setVisible()
  {
    this.state = MineSweeperCellState.Visible;
  }
}