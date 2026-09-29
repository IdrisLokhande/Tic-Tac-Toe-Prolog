:- module(ai, [
    best_move/3
]).

:- use_module(board).


% ----- Move Ordering -----

% Priority:
% Wins -> Blocks -> Strategic -> Others

order_moves(Board, Player, Moves, Ordered) :-
    switch(Player, Opp),

    % Winning moves for Player
    findall(
        Pos,
        (
            member(Pos, Moves),
            wins_if_played(Board, Player, Pos)
        ),
        Wins
    ),

    % Blocking moves against Opponent
    findall(
        Pos,
        (
            member(Pos, Moves),
            wins_if_played(Board, Opp, Pos)
        ),
        Blocks
    ),

    % Remove Wins and Blocks
    subtract(Moves, Wins, Rest1),
    subtract(Rest1, Blocks, Rest2),

    % Strategic positions
    strategic(Rest2, Strats, Others),

    % Final ordering
    append(
        [Wins, Blocks, Strats, Others],
        Ordered
    ).


% ----- Immediate Winning Move -----

wins_if_played(Board, P, Pos) :-
    board:replace(Board, Pos, P, NewBoard),
    board:winner(NewBoard, P).


% ----- Strategic Positions -----

strategic(Moves, Strats, Others) :-
    board:dim(d, X),
    center_group(X, CenterGroup),

    findall(
        Pos,
        (
            member(Pos, Moves),
            memberchk(Pos, CenterGroup)
        ),
        Strats
    ),

    subtract(Moves, Strats, Others).


% ----- Center Group -----

center_group(N, CenterGroup) :-
    S is integer(sqrt(N)),
    Start is 1 + (S + 1),
    Len is S - 2,
    L1 is Len - 1,

    findall(
        Pos,
        (
            between(0, L1, R),
            between(0, L1, C),
            Pos is Start + R * S + C
        ),
        CenterGroup
    ).


% ----- Best Move -----

best_move(Board, Player, BestPos) :-
    board:max_depth(m, MaxDepth),

    negamax_dl(
        Board,
        Player,
        0,
        MaxDepth,
        -100,
        +100,
        BestPos,
        _
    ).


% ----- Depth-Limited Negamax -----

negamax_dl(
    Board,
    Player,
    Depth,
    MaxDepth,
    Alpha,
    Beta,
    BestMove,
    BestScore
) :-
    (
        Depth >= MaxDepth
    ->
        eval(Board, Player, BestScore),
        BestMove = nil

    ;
        board:game_over(Board, Winner)
    ->
        score(Winner, Player, BestScore),
        BestMove = nil

    ;
        findall(
            Pos,
            nth1(Pos, Board, e),
            Moves
        ),

        order_moves(
            Board,
            Player,
            Moves,
            Ordered
        ),

        Depth1 is Depth + 1,

        negamax_loop(
            Ordered,
            Board,
            Player,
            Depth1,
            MaxDepth,
            Alpha,
            Beta,
            nil,
            BestMove,
            BestScore
        )
    ).


% ----- Negamax Loop -----

negamax_loop(
    [],
    _,
    _,
    _,
    _,
    Alpha,
    _,
    CurrBest,
    CurrBest,
    Alpha
).

negamax_loop(
    [M|Ms],
    Board,
    Player,
    Depth,
    MaxDepth,
    Alpha,
    Beta,
    PrevBest,
    BestMove,
    BestScore
) :-

    board:replace(
        Board,
        M,
        Player,
        NextBoard
    ),

    switch(Player, Opp),

    negamax_dl(
        NextBoard,
        Opp,
        Depth,
        MaxDepth,
        -Beta,
        -Alpha,
        _,
        ChildVal0
    ),

    Score is -ChildVal0,

    % Alpha update
    (
        Score > Alpha
    ->
        Alpha1 = Score,
        CurrBest = M

    ;
        Alpha1 = Alpha,
        CurrBest = PrevBest
    ),

    % Beta cutoff
    (
        Alpha1 >= Beta
    ->
        BestMove = CurrBest,
        BestScore = Alpha1

    ;
        negamax_loop(
            Ms,
            Board,
            Player,
            Depth,
            MaxDepth,
            Alpha1,
            Beta,
            CurrBest,
            BestMove,
            BestScore
        )
    ).


% ----- Evaluation -----

eval(Board, Player, Score) :-
    board:dim(d, Len),
    board:gen_lines(Len, Lines),

    switch(Player, Opp),

    include(
        can_win(Board, Player),
        Lines,
        MyLines
    ),

    include(
        can_win(Board, Opp),
        Lines,
        OppLines
    ),

    length(MyLines, ML),
    length(OppLines, OL),

    Score is ML - OL.


% ----- Line Evaluation -----

can_win(Board, P, Line) :-
    \+ (
        member(Pos, Line),
        nth1(Pos, Board, Cell),
        Cell \= P,
        Cell \= e
    ).


% ----- Terminal Scores -----

score(Winner, Player, 1) :-
    Winner == Player.

score(Winner, Player, -1) :-
    Winner \== Player,
    Winner \== draw.

score(draw, _, 0).


% ----- Player Switching -----

switch(x, o).
switch(o, x).
