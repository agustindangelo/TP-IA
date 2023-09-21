:- dynamic juguete/7.

abrir_db :-
  retractall(juguete(_,_,_,_,_)),
  consult('./Base/Datos.txt').
  
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

% pertenece(X, [X|_]).
% pertenece(X, [_|T]) :- pertenece(X, T).

pertenece([H|_], [H|_]).
pertenece([H|T1], L) :- pertenece(T1, L).
pertenece([], [_|T]) :- pertenece(T1, [H|T2]).

incluye([H|_], [H|_], _).
incluye([H|T1], L, Lista) :- pertenece2(H, L), Lista is [H|Lista1], incluye([]).
pertenece2([H|_], [H|_]).
pertenece2([H|T1], L) :- pertenece2(T1, L).
pertenece2([], [_|T]) :- pertenece2(T1, [H|T2]).

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
    write('\nIngrese la modalidad de juego (individual/grupal): '), read(Modalidad),
    buscar_juguete(Edad, Genero, Tematicas, Modalidad, PrecioMax).

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
	% buscar_por_tematica(Tematicas).
	
buscar_juguete(Edad, Genero, Tematicas, Modalidad, Pmax):-
	retract(juguete(Descripcion, EdadMin, EdadMax, Genero, Tematica, Modalidad, Precio)),
    EdadMin =< Edad,
    EdadMax >= Edad,
    Pmax >= Precio,
    pertenece(Tematica, Tematicas),
    write('Juguete:'), write(Descripcion), write('- Precio: '), write(Precio), write('- Tematica'), write(Tematica),
    buscar_juguete(Edad, Genero, Tematicas, Modalidad, Pmax).

buscar_juguete(_, _, _, _, _).

% buscar_por_tematica

% buscar_por_tematica(TematicasElegidas):-
%     retract(juguete(Descripcion, EdadMin, EdadMax, Genero, Tematicas, Modalidad, Precio)),
%     pertenece(Tematicas, TematicasElegidas)

% listar_juguetes(EdadMin, EdadMax, Tematica, Modalidad, Lista):-
% listar_juguetes(_,_,_,_,[]).
% %Lista is [Descripcion|Lista2], listar_juguetes(EdadMin, EdadMax, Tematica, Modalidad, Lista2).
% % listar_juguetes(_,_,_,_,[]).