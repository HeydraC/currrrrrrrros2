# Proyecto 2
# Parte 1
Para el predicado initialBoard(VehicleList) se implementaron los predicados auxiliares inBoard, pos, check, mapAll y loadVehicles.
- inBoard comprueba que un par (Fila, Columna) está dentro del tablero.
- pos asocia un vehículo con una lista que contiene todas las casillas del tablero que ocupa y comprueba que el vehículo no tenga coordenadas fuera del tablero.
- check toma una lista de coordenadas y comprueba si tiene elementos repetidos. Para esto la compara con la lista asociada a la misma mediante el predicado sort, que además de ordenarla elimina los elementos repetidos.
- mapAll asocia una lista de vehículos con una lista que contiene todas las coordenadas de los mismos obtenidas mediante pos.
- loadVehicles recibe una lista de vehículos y los carga a la base de conocimientos.
Así, initialboard genera una lista con todas las coordenadas de los vehículos, comprueba que no haya coordenadas repetidas ni fuera del tablero y de cumplirse eso carga los vehículos en la base de conocimientos.
# Parte 2
Para isValidMove(ID, Steps) se implementó primero moveVehicle para usar como predicado auxiliar, también se implementó validate para trabajar con la lista de vehículos ya obtenida de la base de conocimientos.

isValidMove obtiene los vehículos de la base de conocimientos, obtiene una lista con el vehículo movido con moveVehicle y comprueba que no hayan vehículos chocando o saliendo del tablero en cada paso intermedio del movimiento pedido.
# Parte 3
moveVehicle usa select para obtener el vehículo pedido y la lista de vehículos sin el mismo, genera un vehículo con las coordenadas modificadas en base a su orientación y asocia esto con el estado obtenido al agregar nuevamente el vehículo desplazado.
# Parte 4
Para solveRushHour(StartBoard, Solution) se implementaron los predicados auxiliares goal, genMove, extractStates y bfs.
- goal comprueba si en un estado el vehículo de Id 0 está tocando la columna 5 del tablero.
- genMove comprueba que el Id y el número de pasos sean valores válidos, vacía la base de conocimientos y carga a la misma el estado recibido para luego comprobar si se puede hacer el movimiento, y en caso de poder se realiza el mismo.
- extractStates toma una lista de listas de forma [estado, camino recorrido] y lo asocia a una lista con sólo los estados visitados, para así agregarlo a la lista de estados visitados en el bfs con el fin de evitar ciclos.

El predicado bfs primero comprueba si el estado actual llegó a la meta, para asociar al mismo la ruta mediante la que lo consigue.
En caso de no cumplirse esto, toma una cola de listas de forma [estado, camino recorrido] y una lista de estados visitados y los asocia a una lista de pasos que llevan a la solución más corta. Para esto primero genera una lista de hijos del estado actual asegurando que los mismos sean válidos y ordenándolos para poder compararlos con los de la lista de visitados, luego los agrega a la cola y a la lista de visitados y por último hace una llamada recursiva con la nueva información.

Así solveRushHour comprueba que StartBoard sea un estado válido y carga sus vehículos a la base de conocimientos, ordena la lista para que luego pueda ser comparada con otras, obtiene la solución mediante bfs e invierte la misma para obtener los pasos en el orden correcto.
