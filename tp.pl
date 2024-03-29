:- dynamic juguete/7.

abrir_db:-
  retractall(juguete(_,_,_,_,_,_,_)),
  consult('C:/Users/adangelo/code/TP-IA/Base/Datos.txt').
  
cls :- write('\e[H\e[2J').

menu:-
  cls,
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

leer([TematicaMinus|T]):- 
  write('\n¿Ingrese una tematica (doble corchete para finalizar el ingreso): '), 
  read(Tematica),
  Tematica \= [], 
  string_lower(Tematica, TematicaMinus),
  leer(T).
leer([]).

imprimirTematicas:-
  writeln('\n\t- Musica'),
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
  writeln('\t- Coleccionismo').

seleccionar(1):- 
  write('ASESORAMIENTO PARA UN NUEVO CLIENTE: '),
  write('\n¿Cuantos anios tiene la persona?: '), read(Edad),
  write('\n¿Cuales son sus intereses: '),
  imprimirTematicas,
  leer(Tematicas),
  write('\n¿Cual es su genero? '), read(Genero), string_lower(Genero, GeneroMinus),
  write('\n¿Cual es el precio maximo que esta dispuesto a pagar? '), read(PrecioMax),
  buscarJuguetes(Edad, GeneroMinus, Tematicas, PrecioMax, JugPosibles),
  mostrarJuguetes(JugPosibles).

seleccionar(2):-
	writeln('¿Cual es una tematica de interes de las siguientes?: '),
  imprimirTematicas,
  leer(Tematicas),
  buscarPorTematicas(Tematicas, JugPosibles),
  mostrarJuguetes(JugPosibles).

seleccionar(3):-
  write('¿Cual es el nombre del juguete o su marca?: '),
  read(Palabra), string_lower(Palabra, PalabraMinus),
  buscarPorPalabra(PalabraMinus, JugPosibles),
  mostrarJuguetes(JugPosibles).

mostrarJuguetes([JugueteID | RestoIDs]):-
  abrir_db,
  retract(juguete(JugueteID, Descripcion, _, _, _, Tematicas, Precio)),
  write('\t -->'), write(JugueteID), write(' - '), write(Descripcion), write(' $'), write(Precio), write(' - Tematicas: '), write(Tematicas),
  writeln(''),
  mostrarJuguetes(RestoIDs).
mostrarJuguetes([]):- write('\n\n Ingrese x para volver al menu: '), read(_).

buscarJuguetes(Edad, Genero, TematicasInteres, Pmax, [JugueteID | Resto]):-
  retract(juguete(JugueteID, _, EdadMin, EdadMax, GeneroJuguete, Tematicas, Precio)),
  tematicasCoinciden(Tematicas, TematicasInteres),
  evaluarGeneroJuguete(Genero, GeneroJuguete),
  EdadMin =< Edad,
  EdadMax >= Edad,
  Pmax >= Precio,
  buscarJuguetes(Edad, Genero, TematicasInteres, Pmax, Resto).
buscarJuguetes(_, _, _, _, []).

buscarPorPalabra(Palabra, [JugueteID | Resto]):-
  retract(juguete(JugueteID, Descripcion, _, _, _, _, _)),
  string_lower(Descripcion, DescripcionMinus),
  sub_atom(DescripcionMinus, _, _, _, Palabra),
  buscarPorPalabra(Palabra, Resto).
buscarPorPalabra(_, []).

buscarPorTematicas(TematicasInteres, [JugueteID | Resto]):-
  retract(juguete(JugueteID, _, _, _, _, Tematicas, _)),
  tematicasCoinciden(Tematicas, TematicasInteres),
  buscarPorTematicas(TematicasInteres, Resto).
buscarPorTematicas(_, []).

tematicasCoinciden(_, []).
tematicasCoinciden([Tematica | _], TematicasInteres):-
  string_lower(Tematica, TematicaMinus),
  pertenece(TematicaMinus, TematicasInteres).
tematicasCoinciden([_ | Resto], TematicasInteres):-
  tematicasCoinciden(Resto, TematicasInteres).

pertenece(X, [X | _]).
pertenece(X, [_ | Resto]):- pertenece(X, Resto).

evaluarGeneroJuguete(Genero, Genero).
evaluarGeneroJuguete(_, n).
