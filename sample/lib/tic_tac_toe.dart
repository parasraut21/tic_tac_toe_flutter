import 'package:flutter/material.dart';
import 'dart:math';

class TicTacToe extends StatefulWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  bool isPlayerTurn = true; // true for player 1, false for computer
  String winner = '';
  bool isDraw = false;

  void makeComputerMove() {
    // Basic random move for the computer
    var emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          emptyCells.add([i, j]);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      var randomIndex = Random().nextInt(emptyCells.length);
      var randomCell = emptyCells[randomIndex];
      setState(() {
        board[randomCell[0]][randomCell[1]] = 'O'; // Computer's move
        checkForWinner(); // Check for a winner after computer's move
        if (winner == '') {
          isPlayerTurn = true; // Switch back to player's turn if no winner
          checkForDraw(); // Check for a draw
        }
      });
    }
  }

  void resetBoard() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      isPlayerTurn = true;
      winner = ''; // Reset the winner status
      isDraw = false; // Reset the draw status
    });
  }

  void checkForWinner() {
    // Check rows, columns, and diagonals for a winning combination
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != '' && board[i][0] == board[i][1] && board[i][1] == board[i][2]) {
        setState(() {
          winner = board[i][0]; // Set the winner
        });
      }
      if (board[0][i] != '' && board[0][i] == board[1][i] && board[1][i] == board[2][i]) {
        setState(() {
          winner = board[0][i]; // Set the winner
        });
      }
    }
    if (board[0][0] != '' && board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
      setState(() {
        winner = board[0][0]; // Set the winner
      });
    }
    if (board[0][2] != '' && board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
      setState(() {
        winner = board[0][2]; // Set the winner
      });
    }
  }

  void checkForDraw() {
    bool draw = true;
    for (var row in board) {
      if (row.contains('')) {
        draw = false;
        break;
      }
    }
    if (draw && winner == '') {
      setState(() {
        isDraw = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe - Made By Paras Raut"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 3; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int j = 0; j < 3; j++)
                      GestureDetector(
                        onTap: () {
                          if (isPlayerTurn && board[i][j] == '') {
                            setState(() {
                              board[i][j] = 'X'; // Player 1's move
                              checkForWinner(); // Check for a winner after player's move
                              if (winner == '') {
                                isPlayerTurn = false; // Switch to computer's turn if no winner
                                makeComputerMove(); // Computer makes a move
                              }
                              checkForDraw(); // Check for a draw after player's move
                            });
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              board[i][j],
                              style: TextStyle(fontSize: 40, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              if (winner != '' || isDraw)
                Column(
                  children: [
                    Text(
                      winner != '' ? 'Winner: $winner' : 'It\'s a Draw!',
                      style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: resetBoard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Play Again',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
