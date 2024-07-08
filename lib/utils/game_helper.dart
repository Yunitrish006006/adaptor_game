import 'dart:math';

class MineSweeperGame {
  static int row = 6;
  static int col = 6;
  static int cells = row * col;
  String mode = "defuse";
  bool gameOver = false;
  int flagCount = 0;
  static int mineCountSetting = 6;
  List<Cell> gameMap = [];
  bool win = false;
  static List<List<Cell>> map = List.generate(
      row, (x) => List.generate(col, (y) => Cell(x, y, "", false)));
  void generateMap() {
    placeMines(mineCountSetting);
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        gameMap.add(map[i][j]);
      }
    }
  }

  void resetGame() {
    map = List.generate(
        row, (x) => List.generate(col, (y) => Cell(x, y, "", false)));
    gameMap.clear();
    flagCount = 0;
    mode = "defuse";
    generateMap();
  }

  static void placeMines(int minesNumber) {
    Random random = Random();
    for (int i = 0; i < minesNumber; i++) {
      int mineRow = random.nextInt(row);
      int mineCol = random.nextInt(col);
      if (map[mineRow][mineCol].content != "X") {
        map[mineRow][mineCol] = Cell(mineRow, mineCol, "X", false);
      }
    }
  }

  void showMines() {
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (map[i][j].content == "X") {
          map[i][j].reveal = true;
        }
      }
    }
  }

  void sweepCell(Cell cell) {
    if (cell.flagged) return;
    if (cell.content == "X" || getLeftMine() == 0) {
      showMines();
      gameOver = true;
    } else {
      int mineCount = 0;
      int cellRow = cell.row;
      int cellCol = cell.col;
      for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, row - 1); i++) {
        for (int j = max(cellCol - 1, 0); j <= min(cellCol + 1, col - 1); j++) {
          if (map[i][j].content == "X") {
            mineCount++;
          }
        }
      }
      cell.content = mineCount;
      cell.reveal = true;
      if (mineCount == 0) {
        for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, row - 1); i++) {
          for (int j = max(cellCol - 1, 0);
              j <= min(cellCol + 1, col - 1);
              j++) {
            if (map[i][j].content == "") {
              sweepCell(map[i][j]);
            }
          }
        }
      }
    }
  }

  void flagCell(Cell cell) {
    if (cell.reveal) return;
    if (cell.flagged) {
      cell.flagged = false;
      flagCount--;
    } else {
      cell.flagged = true;
      flagCount++;
    }
    if (flagCount >= getActualMine()) {
      gameOver = true;
      if (getLeftMine() > 0) {
        win = false;
        showMines();
      } else {
        win = true;
      }
    }
  }

  int getLeftMine() {
    int leftMineCount = 0;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (map[i][j].content == "X" && map[i][j].flagged == false) {
          leftMineCount++;
        }
      }
    }
    return leftMineCount;
  }

  int getActualMine() {
    int leftMineCount = 0;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (map[i][j].content == "X") {
          leftMineCount++;
        }
      }
    }
    return leftMineCount;
  }
}

class Cell {
  int row;
  int col;
  dynamic content;
  bool reveal = false;
  bool flagged = false;
  Cell(this.row, this.col, this.content, this.reveal);
}
