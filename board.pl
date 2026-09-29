:- module(board, [
    dim/2,
    max_depth/2,
    empty_board/2,
    replace/4,
    game_over/2,
    winner/2,
    winner_line/3,
    gen_lines/2
]).


% ----- Configuration -----

dim(d, 9).

max_depth(m, 7).


% ----- Board Initialization -----

empty_board(1, [e]).

empty_board(N, [e|T]) :-
    N > 0,
    N1 is N - 1,
    empty_board(N1, T).


% ----- Game Over Check -----

game_over(Board, x) :-
    winner(Board, x),
    !.

game_over(Board, o) :-
    winner(Board, o),
    !.

game_over(Board, draw) :-
    \+ member(e, Board).


% ----- Winner Detection -----

winner(Board, P) :-
    dim(d, X),
    gen_lines(X, Lines),
    member(Line, Lines),
    winner_line(Line, Board, P),
    !.


winner_line(Line, Board, P) :-
    forall(
        member(Pos, Line),
        nth1(Pos, Board, P)
    ).


% ----- Generate Winning Lines -----

gen_lines(Len, Lines) :-
    N is integer(sqrt(Len)),
    N1 is N - 1,
    N2 is N + 1,

    % Rows
    findall(
        Row,
        (
            between(0, N1, R),
            Start is R * N + 1,
            End is R * N + N,
            findall(
                Pos,
                between(Start, End, Pos),
                Row
            )
        ),
        Rows
    ),

    % Columns
    findall(
        Col,
        (
            between(1, N, C),
            findall(
                Pos,
                (
                    between(0, N1, I),
                    Pos is N * I + C
                ),
                Col
            )
        ),
        Cols
    ),

    % Main diagonals
    findall(
        D,
        (
            between(0, N1, I),
            D is 1 + I * N2
        ),
        Diag1
    ),

    findall(
        D,
        (
            between(0, N1, I),
            D is N + I * N1
        ),
        Diag2
    ),

    append(Rows, Cols, Temp),
    append(Temp, [Diag1, Diag2], Lines).


% ----- Replace Nth Element -----

replace([_|T], 1, X, [X|T]).

replace([H|T], N, X, [H|R]) :-
    N > 1,
    N1 is N - 1,
    replace(T, N1, X, R).
