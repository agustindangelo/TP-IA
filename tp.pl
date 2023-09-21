:- dynamic juguete/7.

abrir_db :-
  retractall(juguete(_,_,_,_,_,_,_)),
  consult('./Base/Datos.txt').
  
menu:-
  writeln('       _                        ____        _   '),
  writeln('      | |                      |  _ \\      | |  '),
  writeln('      | |_   _  __ _ _   _  ___| |_) | ___ | |_ '),
  writeln('  _   | | | | |/ _` | | | |/ _ \\  _ < / _ \\| __|'),
  writeln(' | |__| | |_| | (_| | |_| |  __/ |_) | (_) | |_ '),
  writeln('  \\____/ \\__,_|\\__, |\\__,_|\\___|____/ \\___/ \\__|'),
  writeln('                __/ |                           '),
  writeln('               |___/   Tu asistente de ventas   '),
  writeln(''),
  writeln(' ---- Elija una opcion --------------------'),
  writeln('| 1. Asesorar a un nuevo cliente           |'),
  writeln('| 2. Buscar juguetes por tematicas         |'),
  writeln('| 3. Buscar juguetes por palabra clave     |'),
  writeln('| x. Salir                                 |'),
  writeln(' ------------------------------------------'),
  read(Opt),
  Opt \= x,
  abrir_db,
  seleccionar(Opt),
  menu.
menu.

leer([TematicaMinus|T]) :- 
  write('\nIngrese una tematica (doble corchete para finalizar el ingreso): '), 
  read(Tematica),
  Tematica \= [], 
  string_lower(Tematica, TematicaMinus),
  leer(T).
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
  write('\nIngrese el genero de la persona: '), read(Genero), string_lower(Genero, GeneroMinus),
  write('\nIngrese el precio maximo del juguete: '), read(PrecioMax),
  buscarJuguetes(Edad, GeneroMinus, Tematicas, PrecioMax, JugPosibles),
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
  writeln('\t- Coleccionismo'),
  leer(Tematicas),
  buscarPorTematicas(Tematicas, JugPosibles),
  mostrarJuguetes(JugPosibles).

seleccionar(3) :-
  write('Ingrese el nombre del juguete o su marca: '),
  read(Palabra), string_lower(Palabra, PalabraMinus),
  buscarPorPalabra(PalabraMinus, JugPosibles),
  mostrarJuguetes(JugPosibles).

mostrarJuguetes([JugueteID | RestoIDs]):-
  abrir_db,
  retract(juguete(JugueteID, Descripcion, _, _, _, Categorias, Precio)),
  write(JugueteID), write(' - '), write(Descripcion), write(' $'), write(Precio), write(' - Categorias: '), write(Categorias),
  writeln(''),
  mostrarJuguetes(RestoIDs).
mostrarJuguetes([]).

buscarJuguetes(_, _, [], _, []).
buscarJuguetes(Edad, Genero, CatInteres, Pmax, [JugueteID | Resto]):-
  retract(juguete(JugueteID, _, EdadMin, EdadMax, GeneroJuguete, Categorias, Precio)),
  categoriasCoinciden(Categorias, CatInteres),
  evaluarGeneroJuguete(Genero, GeneroJuguete),
  EdadMin =< Edad,
  EdadMax >= Edad,
  Pmax >= Precio,
  buscarJuguetes(Edad, Genero, CatInteres, Pmax, Resto).
buscarJuguetes(_, _, _, _, []).

buscarPorPalabra(Palabra, [JugueteID | Resto]) :-
  retract(juguete(JugueteID, Descripcion, _, _, _, _, _)),
  string_lower(Descripcion, DescripcionMinus),
  sub_atom(DescripcionMinus, _, _, _, Palabra),
  buscarPorPalabra(Palabra, Resto).
buscarPorPalabra(_, []).

buscarPorTematicas(Tematicas, [JugueteID | Resto]) :-
  retract(juguete(JugueteID, _, _, _, _, Categorias, _)),
  categoriasCoinciden(Categorias, Tematicas),
  buscarPorTematicas(Tematicas, Resto).
buscarPorTematicas(_, []).

categoriasCoinciden([Cat | _], CatInteres):-
  string_lower(Cat, CatMinus),
  pertenece(CatMinus, CatInteres).
categoriasCoinciden([_ | Resto], CatInteres):-
  categoriasCoinciden(Resto, CatInteres).

pertenece(X, [X | _]).
pertenece(X, [_ | Resto]):- pertenece(X, Resto).

evaluarGeneroJuguete(Genero, Genero).
evaluarGeneroJuguete(_, n).