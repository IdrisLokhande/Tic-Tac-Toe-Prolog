:- module(display, [
    display_board/1
]).

:- use_module(board).


% ----- Display -----

display_board(Board) :-
    board:dim(d, X),
    N is integer(sqrt(X)),
    maplist(cell_char, Board, Chars),
    rows(Chars, N, Rows),
    print_rows(Rows).


% ----- Convert Flat List to Rows -----

rows([], _, []).

rows(Flat, N, [Row|Rows]) :-
    length(Row, N),
    append(Row, Tail, Flat),
    rows(Tail, N, Rows).


% ----- Print Rows -----

print_rows([Last]) :-
    print_row(Last).

print_rows([R|Rs]) :-
    board:dim(d, X),
    N is integer(sqrt(X)) - 1,

    print_row(R),
    print_sep(N),
    writeln('---'),

    print_rows(Rs).


% ----- Row Separators -----

print_sep(1) :-
    write('---+').

print_sep(N) :-
    N > 0,
    N1 is N - 1,
    write('---+'),
    print_sep(N1).


% ----- Print One Row -----

print_row(Cells) :-
    intersperse(Cells, ' | ', Frags),
    atomic_list_concat(Frags, '', Line),
    format(' ~w~n', [Line]).


% ----- Intersperse -----

intersperse([], _, []).

intersperse([X], _, [X]).

intersperse([H|T], Sep, [H,Sep|Rest]) :-
    intersperse(T, Sep, Rest).


% ----- Cell Display Characters -----

cell_char(e, ' ').
cell_char(x, 'x').
cell_char(o, 'o').
