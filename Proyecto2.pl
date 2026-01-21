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

loadVehicles([]).
loadVehicles([v(Id, Dir, Row, Col, Len) | Resto]) :-
    assertz(vehiculo(Id, Dir, Row, Col, Len)), 
    loadVehicles(Resto).

initialBoard(VehicleList) :- 
  retractall(vehiculo(_,_,_,_,_)),
  mapAll(VehicleList, AllCoords),
  check(AllCoords),
  loadVehicles(VehicleList).

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

validate(_, _, 0) :- !.
validate(VehicleList, ID, Steps) :-
    Steps \= 0,
    (Steps > 0 -> Unit = 1 ; Unit = -1),
    moveVehicle(VehicleList, ID, Unit, Intermediary),
    initialBoard(Intermediary), 
    NewSteps is Steps - Unit,
    validate(Intermediary, ID, NewSteps).

isValidMove(ID, Steps) :-
    findall(v(Id, Dir, Row, Col, Len), vehiculo(Id, Dir, Row, Col, Len), VehicleList),
    Steps \= 0,
    (Steps > 0 -> Unit = 1 ; Unit = -1),
    moveVehicle(VehicleList, ID, Unit, Intermediary),
    initialBoard(Intermediary), 
    NewSteps is Steps - Unit,
    validate(Intermediary, ID, NewSteps).

solveRushHour(StartBoard, Solution) :-
    initialBoard(StartBoard),
    sort(StartBoard, StartSorted),
    bfs([[StartSorted, []]], [StartSorted], SolutionReverse),
    reverse(SolutionReverse, Solution).

bfs([[State, Route] | _], _, Route) :- goal(State).
bfs([[State, Route] | Queue], Visited, Solution) :-
    findall(
        [RootState, [(Id, Steps) | Route]],
        (
            genMove(State, Id, Steps, NewState),
            sort(NewState, RootState),
            \+ member(RootState, Visited)
        ),
      Children
    ),
    
    extractStates(Children, NewStates),
    append(Visited, NewStates, NewVisited),
  
    append(Queue, Children, NewQueue),
    
    bfs(NewQueue, NewVisited, Solution).    

goal(State) :-
    member(v(0, h, _, Col, Len), State),
    Position is Col + Len - 1,
    Position =:= 5.

genMove(State, Id, Steps, NewState) :-
    member(v(Id, _, _, _, _), State),
    member(Steps, [1, -1, 2, -2, 3, -3, 4, -4]),
    
    retractall(vehiculo(_,_,_,_,_)),
    loadVehicles(State),
    isValidMove(Id, Steps),
    
    moveVehicle(State, Id, Steps, NewState).

extractStates([], []).
extractStates([[E, _]|T], [E|R]) :-
    extractStates(T, R).
