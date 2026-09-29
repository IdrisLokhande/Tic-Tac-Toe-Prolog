# Tic-Tac-Toe

> A Prolog-based Tic-Tac-Toe game featuring Human vs AI and AI vs AI modes.
> Implements depth-limited Negamax with Alpha-Beta pruning and heuristic move ordering.
> Built as a learning project for exploring logic programming, game search, and AI in Prolog.

## Overview

This is a Prolog implementation of the classic Tic-Tac-Toe game.

The project uses Prolog's declarative and recursive programming features to represent the game board, determine winning states, generate legal moves, and implement an AI player.

The AI uses:

* Depth-Limited Negamax
* Alpha-Beta pruning
* Move ordering
* Immediate winning move detection
* Opponent threat blocking
* Strategic center-position prioritisation
* A heuristic evaluation function based on potential winning lines

The project supports both **Human vs AI** and **AI vs AI** game modes.

## Features

* Human vs AI gameplay
* AI vs AI gameplay
* Configurable board size through the board configuration
* Configurable AI search depth
* Automatic win and draw detection
* Alpha-Beta pruning for reducing unnecessary search
* Move ordering for improving search efficiency
* Heuristic evaluation at the depth limit
* Console-based board display

## AI

The AI uses **Negamax**, a variant of Minimax that takes advantage of the symmetry between the two players.

The search is depth-limited and uses **Alpha-Beta pruning**:

```text
Current Position
       |
       v
 Generate Legal Moves
       |
       v
   Order Moves
       |
       +---- Winning Moves
       |
       +---- Blocking Moves
       |
       +---- Strategic Moves
       |
       +---- Remaining Moves
       |
       v
 Depth-Limited Negamax
       |
       v
 Alpha-Beta Pruning
       |
       v
   Best Move
```

Move ordering prioritises:

1. Immediate winning moves
2. Moves that block the opponent
3. Strategic center positions
4. Remaining legal moves

At the depth limit, the board is evaluated by comparing the number of potential winning lines available to the current player against those available to the opponent.

## Core Repository Structure

```text
TicTacToe/
├── main.pl
├── game.pl
├── board.pl
├── ai.pl
└──  display.pl
```

### `main.pl`

Entry point for running the game.

### `game.pl`

Contains the main game loops, player switching, human input, AI turns, and game announcements.

### `board.pl`

Contains board representation and game-state logic, including:

* Board initialization
* Board modification
* Winning-line generation
* Winner detection
* Draw detection

### `ai.pl`

Contains the AI implementation, including:

* Negamax search
* Alpha-Beta pruning
* Depth limiting
* Move ordering
* Heuristic evaluation
* Strategic move selection

### `display.pl`

Handles console rendering of the board and conversion of the internal board representation into a readable format.

## Requirements

* SWI-Prolog

Tested using SWI-Prolog on Linux.

## Running

Clone the repository and enter the project directory:

```bash
git clone <repository-url>
cd TicTacToe
```

Start SWI-Prolog with:

```bash
swipl main.pl
```

Then start a Human vs AI game:

```prolog
?- main.
```

To start an AI vs AI game:

```prolog
?- game:play_ai_vs_ai.
```

## Configuration

The board size and maximum AI search depth can be configured in `board.pl`.

```prolog
dim(d, 9).
max_depth(m, 7).
```

The default configuration represents a standard 3 × 3 Tic-Tac-Toe board.

Increasing the search depth causes the AI to explore more future positions, at the cost of additional computation.

## Learning Goals

This project was primarily built to explore:

* Prolog syntax and predicate-based programming
* Recursion and backtracking
* Declarative representation of game states
* Game-tree search
* Negamax
* Alpha-Beta pruning
* Move ordering
* Modular Prolog programming

## Notes

The project started as a single Prolog file and was later separated into modules according to their responsibilities.

The AI implementation also contains an older, non-depth-limited Negamax implementation that was used during development before the current depth-limited version.
