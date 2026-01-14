dentro_tablero(Fila, Columna) :-
  Fila >= 0, Fila < 6,
  Columna >= 0, Columna < 6.

pos(v(_,_,_,_,0), []) :- !. % Caso base: longitud 0 no ocupa nada.
pos(v(Id, h, Row, Col, Length), [coord(Row, Col) | Resto]) :-
    Length > 0,
    dentro_tablero(Row, Col),
    NextCol is Col + 1,
    NextLen is Length - 1,
    pos(v(Id, h, Row, NextCol, NextLen), Resto).

pos(v(Id, v, Row, Col, Length), [coord(Row, Col) | Resto]) :-
    Length > 0,
    dentro_tablero(Row, Col),
    NextRow is Row + 1,
    NextLen is Length - 1,
    pos(v(Id, v, NextRow, Col, NextLen), Resto).

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
    
    NuevoVehiculo = v(ID, h, NewRow, Col, Len),
    ListaNueva = [NuevoVehiculo | RestoDeVehiculos].

moveVehicle(ListaOriginal, ID, Steps, ListaNueva) :-
    select(v(ID, h, Row, Col, Len), ListaOriginal, RestoDeVehiculos),
    
    NewCol is Col + Steps,
    
    NuevoVehiculo = v(ID, h, Row, NewCol, Len),
    ListaNueva = [NuevoVehiculo | RestoDeVehiculos].

isValidMove(_, _, 0) :- !.

isValidMove(ListaActual, ID, Steps) :-
    Steps \= 0,
    (Steps > 0 -> Unit = 1 ; Unit = -1),
    
    moveVehicle(ListaActual, ID, Unit, ListaIntermedia),
    
    initialBoard(ListaIntermedia), 
    
    NewSteps is Steps - Unit,
    isValidMove(ListaIntermedia, ID, NewSteps).

solveRushHour(StartBoard, Solution) :-
    sort(StartBoard, StartSorted),
    bfs([[StartSorted, []]], [StartSorted], SolutionReverse),
    reverse(SolutionReverse, Solution).

bfs([[Estado, Ruta] | _], _, Ruta) :-
    meta(Estado).

bfs([[EstadoActual, RutaActual] | RestoCola], Visitados, SolucionFinal) :-
    findall(
        [EstadoCanonico, [(Id, Pasos) | RutaActual]],
        (
            generar_movimiento(EstadoActual, Id, Pasos, NuevoEstado),
            
            sort(NuevoEstado, EstadoCanonico),
            
            \+ member(EstadoCanonico, Visitados)
        ),
        Hijos
    ),
    
    extraer_estados(Hijos, NuevosEstados),
    append(Visitados, NuevosEstados, NuevosVisitados),
    
    append(RestoCola, Hijos, NuevaCola),
    
    bfs(NuevaCola, NuevosVisitados, SolucionFinal).

meta(Tablero) :-
    member(v(0, h, _, Col, Len), Tablero),
    PosicionFinal is Col + Len - 1,
    PosicionFinal =:= 5.

generar_movimiento(Tablero, Id, Pasos, NuevoTablero) :-
    member(v(Id, _, _, _, _), Tablero),
    
    member(Pasos, [1, -1, 2, -2, 3, -3, 4, -4]),
    
    isValidMove(Tablero, Id, Pasos),
    
    moveVehicle(Tablero, Id, Pasos, NuevoTablero).

extraer_estados([], []).
extraer_estados([[E, _]|T], [E|R]) :-
    extraer_estados(T, R).

:-initialization(main).

main :-
  StartBoard =  [v(0, h, 2, 0, 2), v(1, v, 0, 3, 3)],
  
  solveRushHour(StartBoard, Solution),
  
  write(Solution),
  
  halt.
