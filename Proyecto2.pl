dentro_tablero(Fila, Columna) :-
    Fila >= 0, Fila < 6,
    Columna >= 0, Columna < 6.

pos(v(_,_,_,_,0),[]).
pos(v(Id, h, Row, Col, Length), [coord(Row, Col) | RestoDeLista]) :-
    Length > 0,
    dentro_tablero(Row,Col),
    NextCol is Col + 1,
    NextLength is Length - 1,
    pos(v(Id, h, Row, NextCol, NextLength), RestoDeLista).
pos(v(Id, v, Row, Col, Length), [coord(Row, Col) | RestoDeLista]) :-
    Length > 0,
    dentro_tablero(Row,Col),
    NextRow is Row + 1,
    NextLength is Length - 1,
    pos(v(Id, v, NextRow, Col, NextLength), RestoDeLista).

check(AllCoords) :-
    sort(AllCoords, SortedCoords),
    length(AllCoords, LenOriginal),
    length(SortedCoords, LenSorted),
    LenOriginal =:= LenSorted.

map_all([],[]).
map_all([V|Rest], AllCoords) :-
    pos(V, VCoords),
    map_all(Rest, RestCoords),
    append(VCoords, RestCoords, AllCoords).

initialBoard(VList) :- map_all(VList, AllCoords), check(AllCoords).
