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

moveVehicle(ListaOriginal, ID, Steps, ListaNueva) :-
    select(v(ID, v, Row, Col, Len), ListaOriginal, RestoDeVehiculos),
    
    NewRow is Row + Steps,
    
    NuevoVehiculo = v(ID, v, NewRow, Col, Len),
    ListaNueva = [NuevoVehiculo | RestoDeVehiculos].

moveVehicle(ListaOriginal, ID, Steps, ListaNueva) :-
    select(v(ID, h, Row, Col, Len), ListaOriginal, RestoDeVehiculos),
    
    NewCol is Col + Steps,
    
    NuevoVehiculo = v(ID, h, Row, NewCol, Len),
    ListaNueva = [NuevoVehiculo | RestoDeVehiculos].

isValidMove(ListaActual, _, 0) :- !.

isValidMove(ListaActual, ID, Steps) :-
    Steps \= 0,
    
    (Steps > 0 -> Unit = 1 ; Unit = -1),
    
    moveVehicle(ListaActual, ID, Unit, ListaIntermedia),

    initialBoard(ListaIntermedia),
    
    NewSteps is Steps - Unit,
    isValidMove(ListaIntermedia, ID, NewSteps).

:-initialization(main).

main :-
  (isValidMove([v(0,h,2,0,2),v(1,v,2,3,3)],0,2) -> write('Si'); write('No')),
  
  halt.
