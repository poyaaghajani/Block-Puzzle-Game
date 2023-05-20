import 'package:block_puzzle_game/screen/game_board.dart';
import 'package:block_puzzle_game/utils/values.dart';
import 'package:flutter/material.dart';

class Piece {
  Tetromino type;

  Piece({required this.type});

  List<int> position = [];

  // color of tetris piece
  Color get color {
    return tetrominoColors[type] ?? const Color(0xffffffff);
  }

  void initialPiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        position = [-25, -15, -5, -6];
        break;
      case Tetromino.I:
        position = [-35, -25, -15, -5];
        break;
      case Tetromino.O:
        position = [-16, -15, -6, -5];
        break;
      case Tetromino.S:
        position = [-15, -14, -6, -5];
        break;
      case Tetromino.Z:
        position = [-16, -15, -5, -4];
        break;
      case Tetromino.T:
        position = [-4, -5, -6, -15];
        break;
      default:
    }
  }

  // move piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  // rotate piece
  int rotationState = 1;
  void rotatePiece() {
    List<int> newPosition = [];

    // rotate the piece based on it's type
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            // get new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            // update position
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotate station
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            // get new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotate station
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            // get new position
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotate station
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            // get new position
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotate station
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

        break;
      case Tetromino.J:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLength + 1,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.I:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - 2 * rowLength,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;

      // O
      case Tetromino.O:
        break;

      // S
      case Tetromino.S:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;
      // T
      case Tetromino.T:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[2] - rowLength,
              position[2],
              position[2] + 1,
              position[2] + rowLength,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength,
            ];

            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1] - 1,
              position[1],
              position[1] + rowLength,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[2] - rowLength,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            if (piecePostitionIsValid(newPosition)) {
              // update position
              position = newPosition;

              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;

      default:
    }
  }

  // check valid position
  bool positionIsValid(int position) {
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    // if position is taken, return false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    } else {
      return true;
    }
  }

  // check if piece is valid position
  bool piecePostitionIsValid(List<int> piecePosition) {
    bool firstOccupied = false;
    bool lastOccupied = false;

    for (int pos in piecePosition) {
      if (!positionIsValid(pos)) {
        return false;
      }

      int col = pos % rowLength;

      if (col == 0) {
        firstOccupied = true;
      }
      if (col == rowLength - 1) {
        lastOccupied = true;
      }
    }

    return !(firstOccupied && lastOccupied);
  }
}
