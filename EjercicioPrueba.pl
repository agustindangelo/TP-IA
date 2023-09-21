:- dynamic(juguete/7).

abrir_db:-
    retractall(juguete(_,_)),
    consult('Base/DatosBackup.txt').
    
leerCategorias([H|T]):- write('\nIngrese una categoria: '), read(H), H \= [], leerCategorias(T).
leerCategorias([]).

inicio:-
    abrir_db,
    leerCategorias(CatInteres),
    buscarJuguetes(CatInteres, JugPosibles),
    writeln(JugPosibles).

buscarJuguetes([], []).
buscarJuguetes(CatInteres, [Juguete | Resto]):-
    retract(juguete(Juguete, _, _, _, Categorias, _, _)),
    categoriasCoinciden(Categorias, CatInteres),
    buscarJuguetes(CatInteres, Resto).
buscarJuguetes(_, []).

categoriasCoinciden([Cat | _], CatInteres):-
    pertenece(Cat, CatInteres).
categoriasCoinciden([_ | Resto], CatInteres):-
    categoriasCoinciden(Resto, CatInteres).

pertenece(X, [X | _]).
pertenece(X, [_ | Resto]):- pertenece(X, Resto).



