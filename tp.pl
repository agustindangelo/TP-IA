:- dynamic(tematica/3).
:- dynamic(juguete/7).

abrir_db:-
  retractall(juguete(_,_,_,_,_,_,_)),
  consult('./Base/Datos.txt').

menu:-
  cls,
  mostrarLogo,
  writeln('Hola, espero que andes muy bien. Soy JugueBot, tu asesor de compras.'),
  sleep(1),
  mostrarOpciones,
  read(Opt),
  Opt \= x,
  abrir_db,
  seleccionar(Opt),
  writeln('Espero haber sido de ayuda :D !!'),
  sleep(1),
  menu.
menu:- 
  writeln('Hasta luego, que tengas buen dia.'),
  sleep(1),
  cls.

mostrarLogo:-
  writeln('       _                        ____        _   '),
  writeln('      | |                      |  _ \\      | |  '),
  writeln('      | |_   _  __ _ _   _  ___| |_) | ___ | |_ '),
  writeln('  _   | | | | |/ _` | | | |/ _ \\  _ < / _ \\| __|'),
  writeln(' | |__| | |_| | (_| | |_| |  __/ |_) | (_) | |_ '),
  writeln('  \\____/ \\__,_|\\__, |\\__,_|\\___|____/ \\___/ \\__|'),
  writeln('                __/ |                           '),
  writeln('               |___/   Tu asistente de ventas   '),
  writeln('').
mostrarOpciones:-
  writeln(' ---- En que puedo ayudarte hoy? --------------------'),
  writeln('| 1. Recibir asesoramiento para regalar              |'),
  writeln('| 2. Describir un juguete                            |'),
  writeln('| x. Salir                                           |'),
  writeln(' ----------------------------------------------------').

seleccionar(1):- 
  writeln('Perfecto, me encanta esta opcion.'),
  sleep(1),
  writeln('Para ayudarte, tendre que hacerte algunas preguntas primero. No te preocupes, no son muchas...'),
  consultarEdad(Edad),
  consultarGenero(Genero),
  consultarPrecioMax(PrecioMax),
  consultarTematicas(TematicasElegidas, 1),
  subtract(TematicasElegidas, [[]], TematicasFiltradas),
  writeln(TematicasFiltradas),
  buscarJuguetes(Edad, Genero, TematicasFiltradas, PrecioMax, JugPosibles),
  mostrarJuguetes(JugPosibles).
seleccionar(2):-
  write('Perfecto, necesitare que me digas una breve descripcion del juguete que buscas'), read(Descripcion),
  split_string(Descripcion, ' ', ' ', DescripcionSeparada),
  limpiarConectores(DescripcionSeparada, PalabrasClave),
  buscarPorPalabra(PalabrasClave, JugPosibles),
  writeln('Mmm... Se me ocurren estas opciones:'),
  writeln(''),
  mostrarJuguetes(JugPosibles).


%% ------- SECCION DE BUSQUEDA PRINCIPAL --------------------
  %% Regla de consulta de edad validando que se ingrese un numero
  consultarEdad(Edad):-
    write('\t > Cuantos anios tiene la persona a la que deseas regalarle? '),
    read(Edad),
    writeln(''),
    number(Edad).
  consultarEdad(Edad):-
    writeln('Lo siento, no pude entenderte. Asegurate de ingresar un numero...'),
    sleep(1),
    consultarEdad(Edad).

  %% Regla que pregunta solicita el genero del agasajado. m => nene, f => nena
  consultarGenero(Genero):-
    write('\t > Es un nene (m) o una nena (f)? '),
    read(Genero),
    writeln(''),
    validarGenero(Genero).
  consultarGenero(Genero):-
    writeln('Lo siento, no pude entenderte. Asegurate de ingresar "m" para nene, y "f" para nena...'),
    consultarGenero(Genero).
  
  %% Regla que valida que el genero ingresado sea 'm' o 'f'
  validarGenero(m).
  validarGenero(f).

  %% Regla que solicita el ingreso del precio maximo dispuesto a pagar validando que ingrese un numero
  consultarPrecioMax(Precio):-
    write('\t > Hasta que precio maximo esta dispuesto a pagar? $'),
    read(Precio),
    writeln(''),
    number(Precio).
  consultarPrecioMax(Precio):-
    writeln('Lo siento, no pude entenderte. Asegurate de ingresar un numero...'),
    sleep(1),
    consultarPrecioMax(Precio).

  %% Regla que realizar preguntas al usuario relacionadas con las tematicas para ir filtrando intereses
  consultarTematicas([_|R], 4):- 
    write('Te gustaria elegir mas tematicas para agregar? (s|n) '),
    read(Respuesta),
    Respuesta \= n,
    imprimirTematicas,
    leer(R),
    writeln('Genial, esas son las preguntas por ahora...'),
    writeln('Dejame ver que opciones tengo...'),
    sleep(1).
  consultarTematicas([], 4):-
    writeln('Genial, esas son las preguntas por ahora...'),
    writeln('Dejame ver que opciones tengo...'),
    sleep(1).
  consultarTematicas([H|R], CantPreguntas):-
    random(1, 16, TematicaID),
    retract(tematica(TematicaID, Tematica, Articulo)),
    realizarPregunta(CantPreguntas), write(Articulo), write(' '), write(Tematica), write('? (s/n) '),
    read(Respuesta),
    evaluarRespuestaSiNo(Respuesta, TematicaID, H),
    Contador is CantPreguntas + 1,
    consultarTematicas(R, Contador).
  
  %% Regla que evalúa que pregunta realizar en funcion de la cantidad de preguntas realizadas
  realizarPregunta(1):-
    write('\t > Le gusta\\n ').
  realizarPregunta(2):-
    write('\t > Crees que pueda interesarse en ').
  realizarPregunta(3):-
    write('\t > Sabes si disfruta de ').

  %% Regla que valida que la respuesta sea 's' o 'n' para agregar o no la tematica a las de interes  
  evaluarRespuestaSiNo(s, TematicaID, TematicaID):- 
    writeln(''),
    writeln('Genial, lo tendre en cuenta.').
  evaluarRespuestaSiNo(n, _, []):- 
    writeln(''),
    writeln('Que pena, lo tendre en cuenta al recomendarte').
  evaluarRespuestaSiNo(_, TematicaID, H):-
    writeln(''),
    write('Lo siento no pude entenderte...'),
    read(Respuesta),
    evaluarRespuestaSiNo(Respuesta, TematicaID, H).

  %% Regla de busqueda de juguetes segun respuestas principales
  buscarJuguetes(EdadIngresada, GeneroIngresado, TematicasInteres, PrecioMax, [JugueteID | Resto]):-
    retract(juguete(JugueteID, _, EdadMin, EdadMax, Genero, Tematicas, Precio)),
    tematicasCoinciden(Tematicas, TematicasInteres),
    evaluarGeneroJuguete(GeneroIngresado, Genero),
    EdadMin =< EdadIngresada,
    EdadMax >= EdadIngresada,
    PrecioMax >= Precio,
    buscarJuguetes(EdadIngresada, GeneroIngresado, TematicasInteres, PrecioMax, Resto).
  buscarJuguetes(_, _, _, _, []).

  %% Regla que evalúa que el género del juguete sea el ingresado o sea 'n' de no aplica
  evaluarGeneroJuguete(Genero, Genero).
  evaluarGeneroJuguete(_, n).
  
  %% Regla que valida si alguna de las temáticas del juguete coincide con alguna de las elegidas
  tematicasCoinciden(_, []).
  tematicasCoinciden([Tematica | _], TematicasInteres):-
    pertenece(Tematica, TematicasInteres).
  tematicasCoinciden([_ | Resto], TematicasInteres):-
    tematicasCoinciden(Resto, TematicasInteres).
%% ------- FIN SECCION DE BUSQUEDA PRINCIPAL --------------------

%% ------- SECCION DE BUSQUEDA POR PALABRAS ---------------
  %% Regla que recibe una lista de palabras claves ingresadas y busca que existan en la descripcion del juguete
  buscarPorPalabra(Palabras, [JugueteID | Resto]):-
    retract(juguete(JugueteID, Descripcion, _, _, _, _, _)),
    compararDescripcion(Palabras, Descripcion),
    buscarPorPalabra(Palabras, Resto).
  buscarPorPalabra(_, []).

  %% Regla que compara cada palabra clave con las de la descripcion
  compararDescripcion([Palabra|[]], Descripcion):-
    string_lower(Descripcion, DescripcionLower),
    split_string(DescripcionLower, ' ', ' ', DescripcionLista),
    pertenece(Palabra, DescripcionLista).
  compararDescripcion([Palabra|R], Descripcion):-
    string_lower(Descripcion, DescripcionLower),
    split_string(DescripcionLower, ' ', ' ', DescripcionLista),
    pertenece(Palabra, DescripcionLista),
    compararDescripcion(R, Descripcion).

  %% Regla que elimina los conectores 'de', 'la', 'con', 'para' de la descripcion ingresada por el usuario
  limpiarConectores(ListaEntrada, ListaFinal):-
    string_lower(de, LowDe), string_lower(con, LowCon), string_lower(la, LowLa), string_lower(para, LowPara), 
    subtract(ListaEntrada, [LowDe,LowCon,LowLa,LowPara], ListaFinal).
%% ------- FIN SECCION DE BUSQUEDA POR PALABRAS ---------------

%% ------- SECCION DE REGLAS COMUNES ---------------
  %% Limpieza de pantalla
  cls :- write('\e[H\e[2J').
  
  %% Regla que muestra un listado de los juguetes posibles para el usuario
  mostrarJuguetes([JugueteID | RestoIDs]):-
    abrir_db,
    retract(juguete(JugueteID, Descripcion, _, _, _, Tematicas, Precio)),
    write('\t'), write(JugueteID), write(' -> '), write(Descripcion), write(' $'), write(Precio), write(' - Tematicas: '), write(Tematicas),
    writeln(''),
    mostrarJuguetes(RestoIDs).
  mostrarJuguetes([]):-
    writeln(''),
    writeln('--> Son todas las que tengo por ahora D:'),
    writeln(''),
    sleep(1),
    write('(Ingrese cualquier entrada para volver al menu)'), read(_).

  %% Regla que carga las tematicas ingresadas en una lista de tematicas
  leer([TematicaID|T]):- 
    write('\nIngrese el numero de una tematica (x para finalizar): '), 
    read(TematicaID),
    TematicaID \= x,
    leer(T).
  leer([]).

  %% Regla que evalua la pertenencia del elemento en una lista
  pertenece(X, [X | _]).
  pertenece(X, [_ | Resto]):- pertenece(X, Resto).

  %% Regla que muestra un listado de las tematicas 
  imprimirTematicas:-
    retract(tematica(TematicaID, Tematica, _)),
    string_upper(Tematica, TematicaUpper),
    write('\t'), write(TematicaID), write('- '), write(TematicaUpper), writeln(''),
    imprimirTematicas.
  imprimirTematicas.
%% ------- FIN SECCION DE REGLAS COMUNES ---------------