:- module(game, [
    play_human_vs_ai/0,
    play_ai_vs_ai/0
]).

:- use_module(board).
:- use_module(display).
:- use_module(ai).

% ----- Entry Points -----

play_human_vs_ai :-
    board:dim(d, X),
    board:empty_board(X, Board),
    display:display_board(Board),
    play_loop_human(x, Board).

play_ai_vs_ai :-
    board:dim(d, X),
    board:empty_board(X, Board),
    display:display_board(Board),
    play_loop_ai(x, Board).


% ----- Game Loops -----

play_loop_human(Player, Board) :-
    (   board:game_over(Board, Winner)
    ->  announce(Winner)
    ;   ( Player = x
        -> human_turn(Board, NextBoard)
        ;  ai_turn(Board, o, NextBoard)
        ),
        switch(Player, NextPlayer),
        display:display_board(NextBoard),
        play_loop_human(NextPlayer, NextBoard)
    ).


play_loop_ai(Player, Board) :-
    board:dim(d, X),

    (   board:game_over(Board, Winner)
    ->  announce(Winner)

    ;   ( board:empty_board(X, Board)
        -> random_between(1, X, Pos),
           writeln('AI 1 Turn (x)'),
           board:replace(Board, Pos, x, NextBoard)

        ;   ( Player = x
            -> writeln('AI 1 Turn (x)'),
               ai_turn(Board, x, NextBoard)

            ;  writeln('AI 2 Turn (o)'),
               ai_turn(Board, o, NextBoard)
            )
        ),

        switch(Player, NextPlayer),
        display:display_board(NextBoard),
        play_loop_ai(NextPlayer, NextBoard)
    ).


% ----- Player Switching -----

switch(x, o).
switch(o, x).


% ----- Announcements -----

announce(x) :-
    writeln('Congratulations! You (x) win!').

announce(o) :-
    writeln('AI (o) wins.').

announce(draw) :-
    writeln('It\'s a draw!').


% ----- Human Turn -----

human_turn(Board, NewBoard) :-
    board:dim(d, X),

    repeat,
        format('Enter your move (1-~w): ', [X]),
        read(Pos),
        integer(Pos),
        Pos >= 1,
        Pos =< X,
        nth1(Pos, Board, Cell),
        Cell == e,
        !,

    board:replace(Board, Pos, x, NewBoard).


% ----- AI Turn -----

ai_turn(Board, Player, NewBoard) :-
    writeln('AI is thinking...'),

    ai:best_move(Board, Player, Pos),

    format('AI chooses ~w~n', [Pos]),

    board:replace(Board, Pos, Player, NewBoard).
