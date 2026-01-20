inBoard(Fila, Columna) :-
  Fila >= 0, Fila < 6,
  Columna >= 0, Columna < 6.

pos(v(_,_,_,_,0), []) :- !.
pos(v(Id, h, Row, Col, Length), [coord(Row, Col) | Remainder]) :-
    Length > 0,
    inBoard(Row, Col),
    NextCol is Col + 1,
    NextLen is Length - 1,
    pos(v(Id, h, Row, NextCol, NextLen), Remainder).

pos(v(Id, v, Row, Col, Length), [coord(Row, Col) | Remainder]) :-
    Length > 0,
    inBoard(Row, Col),
    NextRow is Row + 1,
    NextLen is Length - 1,
    pos(v(Id, v, NextRow, Col, NextLen), Remainder).

check(AllCoords) :-
  sort(AllCoords, SortedCoords),
  length(AllCoords, LenOriginal),
  length(SortedCoords, LenSorted),
  LenOriginal =:= LenSorted.

mapAll([],[]).
mapAll([V|Remainder], AllCoords) :-
  pos(V, VCoords),
  mapAll(Remainder, RemCoords),
  append(VCoords, RemCoords, AllCoords).

initialBoard(VehicleList) :- mapAll(VehicleList, AllCoords), check(AllCoords).

moveVehicle(CurrentState, ID, Steps, NewState) :-
    select(v(ID, v, Row, Col, Len), CurrentState, Remainder),
    NewRow is Row + Steps,
    NewVehicle = v(ID, v, NewRow, Col, Len),
    NewState = [NewVehicle | Remainder].

moveVehicle(CurrentSate, ID, Steps, NewState) :-
    select(v(ID, h, Row, Col, Len), CurrentSate, Remainder),
    NewCol is Col + Steps,
    NewVehicle = v(ID, h, Row, NewCol, Len),
    NewState = [NewVehicle | Remainder].

isValidMove(_, _, 0) :- !.
isValidMove(VehicleList, ID, Steps) :-
    Steps \= 0,
    (Steps > 0 -> Unit = 1 ; Unit = -1),
    moveVehicle(VehicleList, ID, Unit, Intermediary),
    initialBoard(Intermediary), 
    NewSteps is Steps - Unit,
    isValidMove(Intermediary, ID, NewSteps).

solveRushHour(StartBoard, Solution) :-
    sort(StartBoard, StartSorted),
    bfs([[StartSorted, []]], [StartSorted], SolutionReverse),
    reverse(SolutionReverse, Solution).

bfs([[State, Route] | _], _, Route) :-
    meta(State).

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
