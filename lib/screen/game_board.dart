import 'dart:async';
import 'dart:math';

import 'package:block_puzzle_game/utils/piece.dart';
import 'package:block_puzzle_game/utils/pixel.dart';
import 'package:block_puzzle_game/utils/values.dart';
import 'package:flutter/material.dart';

// crate game board
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

// curent puzzle piece
Piece currentPiece = Piece(type: Tetromino.L);

// current score
int currentScore = 0;

// game over status
bool gameOver = false;

class _GameBoardState extends State<GameBoard> {
  @override
  void initState() {
    super.initState();
    startGame();
  }

  // start game
  void startGame() {
    currentPiece.initialPiece();

    // frame refresh rate
    Duration frameRate = const Duration(milliseconds: 600);
    gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          // clear lines
          clearLines();

          // check landing
          checkLanding();

          // check if game is over
          if (gameOver == true) {
            timer.cancel();
            showGameOverDialog();
          }

          // move current piece down
          currentPiece.movePiece(Direction.down);
        });
      },
    );
  }

  // game over messsage
  void showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score is: $currentScore'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: const Text(
              'Play again',
              style: TextStyle(
                color: Color.fromARGB(255, 144, 0, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // reset game
  void resetGame() {
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    // new game;
    gameOver = false;
    currentScore = 0;

    // create new piece
    createNewPiece();

    // start game again
    startGame();
  }

  // check collision in a future position
  // return true -> there is a collision
  // return false -> there is no collision
  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and col of the current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check if the piece is out of bounds
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      // check if the current position is already occupied by another piece in the game board
      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }
    // if
    return false;
  }

  void checkLanding() {
    // if going down is occupied
    if (checkCollision(Direction.down)) {
      // mark position as occupied on the gemeborad
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      // once landed, create a next piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create a random object to generate random tetromino types
    Random rand = Random();

    // create a new piece with random type
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initialPiece();

    if (isGameOver()) {
      gameOver = true;
    }
  }

  // move left
  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  // move right
  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  // rotate piece
  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  // clear lines
  void clearLines() {
    // step 1: Loop through each rOW of the game board from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      // step 2: Initialize a variable to track if the row is full
      bool rowIsFull = true;

      // step 3: Check if the row if full (all columns in the row are filled with pieces)
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // step 4: if the row is full, clear the row and shift rows down
      if (rowIsFull) {
        // step 5: move all rows above the cleared row down by one position
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        // step 6: set the top row to empty
        gameBoard[0] = List.generate(row, (index) => null);

        // step 7: increase the score
        currentScore++;
      }
    }
  }

  // game over
  bool isGameOver() {
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    // if the top row is empty, the game is not over
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rowLength * colLength,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
              ),
              itemBuilder: (context, index) {
                // get row and col of each index
                int row = (index / rowLength).floor();
                int col = index % rowLength;
                // current piece
                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    color: currentPiece.color,
                  );
                }

                // landed pieces
                else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];

                  return Pixel(
                    color: tetrominoColors[tetrominoType]!,
                  );
                }

                // blank pixel
                else {
                  return Pixel(
                    color: Colors.grey.shade900,
                  );
                }
              },
            ),
          ),

          // score
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'SCORE: $currentScore',
              style: const TextStyle(
                color: Color.fromARGB(255, 144, 0, 255),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // game controls
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    moveLeft();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey.shade200,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    rotatePiece();
                  },
                  icon: Icon(
                    Icons.rotate_left,
                    color: Colors.grey.shade200,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    moveRight();
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
