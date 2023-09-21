:- dynamic juguete/7.

abrir_db :-
  retractall(juguete(_,_,_,_,_)),
  consult('./Base/DatosBackup.txt').
  
menu:-
  writeln('1. Asesorar a un nuevo cliente'),
  writeln('2. Buscar juguetes por temáticas'),
  writeln('x. Salir'),
  read(Opt),
  Opt \= x,
  abrir_db,
  seleccionar(Opt),
  menu.
menu.

leer([H|T]) :- write('\nIngrese una tematica (doble corchete para finalizar el ingreso): '), read(H), H \= [], leer(T).
leer([]).

seleccionar(1) :- 
  write('ASESORAMIENTO PARA UN NUEVO CLIENTE: '),
  write('\nIngrese la edad de la persona: '), read(Edad),
  write('\nIngrese una tematica de interes de las siguientes: '),
  writeln('\t- Musica'),
  writeln('\t- Deportes'),
  writeln('\t- Construccion y diseno'),
  writeln('\t- Ciencia y experimentos'),
  writeln('\t- Disfraces'),
  writeln('\t- Arte y manualidades'),
  writeln('\t- Cocina y comida'),
  writeln('\t- Lectura y escritura'),
  writeln('\t- Figuras de accion'),
  writeln('\t- Naturaleza y animales'),
  writeln('\t- Rompecabezas'),
  writeln('\t- Juegos al aire libre'),
  writeln('\t- Juegos de agua'),
  writeln('\t- Juegos de mesa'),
  writeln('\t- Coleccionismo'),
  leer(Tematicas),
  write('\nIngrese el genero de la persona: '), read(Genero),
  write('\nIngrese el precio maximo del juguete: '), 
  read(PrecioMax),
  buscarJuguetes(Edad, Genero, Tematicas, PrecioMax, JugPosibles),
  mostrarJuguetes(JugPosibles).

seleccionar(2) :-
	writeln('Ingrese una tematica de interes de las siguientes: '),
  writeln('\t- Deportes'),
  writeln('\t- Musica'),
  writeln('\t- Ciencia y experimentos'),
  writeln('\t- Construccion y diseno'),
  writeln('\t- Arte y manualidades'),
  writeln('\t- Disfraces'),
  writeln('\t- Lectura y escritura'),
  writeln('\t- Cocina y comida'),
  writeln('\t- Naturaleza y animales'),
  writeln('\t- Figuras de accion'),
  writeln('\t- Juegos al aire libre'),
  writeln('\t- Rompecabezas'),
  writeln('\t- Juegos de mesa'),
  writeln('\t- Juegos de agua'),
  writeln('\t- Coleccionismo').
  %leer(Tematicas).

mostrarJuguetes([JugueteID | RestoIDs]):-
  retract(juguete(JugueteID, Descripcion, _, _, _, Categorias, _, Precio)),
  write(JugueteID), write(' - '), write(Descripcion), write(' $'), write(Precio), write(' - Categorias: '), write(Categorias),
  writeln(''),
  mostrarJuguetes(RestoIDs).
mostrarJuguetes([]):- abrir_db.

buscarJuguetes(_, _, [], _, _, []).
buscarJuguetes(Edad, Genero, CatInteres, Pmax, [JugueteID | Resto]):-
  retract(juguete(JugueteID, _, EdadMin, EdadMax, Genero, Categorias, Precio)),
  categoriasCoinciden(Categorias, CatInteres),
  EdadMin =< Edad,
  EdadMax >= Edad,
  Pmax >= Precio,
  buscarJuguetes(Edad, Genero, CatInteres, Pmax, Resto).
buscarJuguetes(_, _, _, _, _, []):- abrir_db.

categoriasCoinciden([Cat | _], CatInteres):-
  pertenece(Cat, CatInteres).
categoriasCoinciden([_ | Resto], CatInteres):-
  categoriasCoinciden(Resto, CatInteres).

pertenece(X, [X | _]).
pertenece(X, [_ | Resto]):- pertenece(X, Resto).


% buscar_por_tematica

% buscar_por_tematica(TematicasElegidas):-
%     retract(juguete(Descripcion, EdadMin, EdadMax, Genero, Tematicas, Precio)),
%     pertenece(Tematicas, TematicasElegidas)

% listar_juguetes(EdadMin, EdadMax, Tematica, Lista):-
% listar_juguetes(_,_,_,_,[]).
% %Lista is [Descripcion|Lista2], listar_juguetes(EdadMin, EdadMax, Tematica, Lista2).
% % listar_juguetes(_,_,_,_,[]).