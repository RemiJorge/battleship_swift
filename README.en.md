# Battleship Description

<div align='center'>

[Rules](#rules) | [Ships](#ships) | [Oceans](#oceans) | [Game Modes](#game-modes) | [How to Compile and Run the Files](#how-to-compile-and-run-the-files) | [Credits](#credits) | [License](#license)

French version: [README.md](./README.md) <a href="README.md"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Flag_of_France.svg/1200px-Flag_of_France.svg.png" width="20" height="15" alt="French version"></a>

![image.png](./images/image.png)

Welcome, Dear Players,

Our program allows you to play battleship with the following features:

</div>


# Rules

- Players take turns.
- The active player fires at a position (see game board below), and the program responds:
    - "Hit" if the position is occupied by a ship and hasn't been hit at that position before.
    - "Sunk" if the position is occupied by a ship and it was the last untouched position of the ship.
    - "In sight" if the position is unoccupied or corresponds to a previously hit position, and there is an untouched ship on the same row or column (or both).
    - "Island" if you made a mistake and fired at an island.
    - "Miss" in all other cases.

The active player wins if, after a shot, they sink the last ship in their opponent's fleet.

Each player can visualize:

- Their game board with their ships and indications of hit positions for each ship.
    - Intact ships are represented by □
    - Hit ships are represented by ╳
    - Islands are represented by █
    - Water is represented by an empty space
- Their firing board: the active player can see where they have already fired.
    - Hit ships are represented by ╳
    - Islands are represented by █
    - A shot "in sight" is represented by a +
    - A shot "miss" is represented by a 🞄
    - An unshot position is represented by a ?

# Ships

Each player has 5 ships ranging in size from 1 to 4, including two size 3 ships.
Ships are placed on the game board vertically or horizontally (not diagonally) in consecutive and adjacent positions.
Two ships cannot share the same position.
At the beginning of the game, each player positions their ships on their game board.

# Oceans

The game board consists of multiple oceans, each identified by a name. Each ocean is a rectangular grid. A position is determined by the ocean's name, row, and column in the corresponding grid.
The oceans are as follows:
- Atlantic Ocean, size 6 × 7.
- Pacific Ocean, size 7 × 8.
- Indian Ocean, size 5 × 6.

Each ocean includes an island:
- Azores Island for the Atlantic Ocean.
- Hawaii for the Pacific Ocean.
- Reunion Island for the Indian Ocean.

Each island must have a minimum size of 4 squares arranged as desired.
A ship can only be in sight if it is in the same ocean as the targeted position and is not obscured by the island.

# Game Modes

- Easy: Unlimited number of shots.
- Normal: Limited to 65 shots.
- Difficult: Limited to 50 shots.
- Extreme: Limited to 40 shots.
In modes other than Easy, the game can end in a draw if no fleet has been completely sunk.

# How to Compile and Run the Files

Once you are in the folder with the project files, type the command:
```bash
swiftc *.swift
```
in a terminal to compile all the files.

Then, type the command:
```bash
./main
```
to run the program.

Note: A UTF-8 encoded terminal is required.

# Credits

Our team consists of two passionate programmers, Rémi Jorge and Alexandre Deloire, with their respective roles mentioned below:

- Producer & Game Designer: Rémi Jorge, Alexandre Deloire
- Technical Director: Rémi Jorge
- Studio Director: Alexandre Deloire
- Senior Map Artist: Rémi Jorge
- Senior Lead Test Analyst: Alexandre Deloire
- Senior Programmer: Rémi, Alexandre Deloire
- Development Support: Rémi Jorge
- Scrum Master: Alexandre Deloire
- Lead AI Programmer: Rémi Jorge

# License

<div align="center">
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
</div>