import 'dart:developer';

import 'package:flutter/material.dart';

void main(List<String> args) {
  return runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int player1WinCount = 0;
  int player2WinCount = 0;
  int playerTurn = 0;
  List<List<String>> grid = [
    ["", "", ""],
    ["", "", ""],
    ["", "", ""]
  ];

  reset() {
    setState(() {
      playerTurn = 0;
      grid = [
        ["", "", ""],
        ["", "", ""],
        ["", "", ""]
      ];
    });
  }

  refresh() {
    setState(() {
      reset();
      player1WinCount = 0;
      player2WinCount = 0;
    });
  }

  bool checkIfWon(int x, int y) {
    if (grid[x][0] == grid[x][1] && grid[x][1] == grid[x][2]) {

      return true;
    }
    if (grid[0][y] == grid[1][y] && grid[1][y] == grid[2][y]) {

      return true;
    }
    if (grid[0][0] != "" && grid[1][1] != "" && grid[2][2] != "") {

      if (grid[0][0] == grid[1][1] && grid[1][1] == grid[2][2]) {
        return true;
      }
    }
    if (grid[2][0] != "" && grid[1][1] != "" && grid[0][2] != "") {
      if (grid[0][2] == grid[1][1] && grid[1][1] == grid[2][0]) {
        return true;
      }
    }
    return false;
  }

  compute(int x, int y) {
    setState(() {
      if (grid[x][y] == "") {
        if (playerTurn == 0) {
          grid[x][y] = "O";
          playerTurn = 1;
        } else {
          grid[x][y] = "X";
          playerTurn = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
            onPressed: refresh,
            child: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amber, Colors.green])),
        ),
        centerTitle: true,
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber, Colors.greenAccent],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  'Player O',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Player X',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '$player1WinCount',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$player2WinCount',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                buildGrid(context, 0, 0),
                buildGrid(context, 0, 1),
                buildGrid(context, 0, 2),
              ],
            ),
            Row(
              children: [
                buildGrid(context, 1, 0),
                buildGrid(context, 1, 1),
                buildGrid(context, 1, 2),
              ],
            ),
            Row(
              children: [
                buildGrid(context, 2, 0),
                buildGrid(context, 2, 1),
                buildGrid(context, 2, 2),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            buildTurnWidget(playerTurn),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
              onPressed: reset,
              child: const Text('Reset'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTurnWidget(int playerTurn) {
    return playerTurn == 0
        ? const Text(
            'Turn of O',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
          )
        : const Text(
            'Turn of X',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
          );
  }

  Widget buildGrid(BuildContext context, int x, int y) {
    return Material(
      color: Colors.greenAccent,
      child: InkWell(
        splashColor: Colors.amberAccent,
        onTap: () {
          compute(x, y);
          if (checkIfWon(x, y)) {
            showDialog(
                context: context,
                builder: (context) {
                  if (grid[x][y] == "O") {
                    player1WinCount++;
                  } else {
                    player2WinCount++;
                  }
                  return AlertDialog(
                    title: const Text('Won!!!'),
                    content: Text('Player ${grid[x][y]} Won'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          reset();
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                });
          }
        },
        child: Container(
          height: 150,
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Center(
              child: Text(
            grid[x][y],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
