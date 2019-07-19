ida_star(Path, Actions):- %cose che devono esssere istanziate
  iniziale(Start),
  heuristic(H, Start),
  ida_star_rec(Result, H, 0, Start, [Start], Actions).

ida_star_rec(Result,_,_,_,_,_) :-
  integer(Result).

ida_star_rec(Result, Bound, G, Node, Path, Actions):-
  nb_setval(minF, inf),
  !, %svuoto lo stack del backtraking
  \+search(Result, Bound, G, Node, Path, Actions),
  nb_getval(minF, Min),
  ida_star_rec(Result, Min, G, Node, Path, Actions).

% raggiunto il nodo finale
search(Result,_,_,Node,_,_):-
  finale(Node),
  Result is -1.

% quando il bound è da aggiornare
search(_,Bound, G, Node, _, _) :-
  heuristic(H, Node),
  G+H > Bound,
  nb_getval(minF, Min),
  Min > G+H,
  nb_setval(minF, G+H),
  false.
  % devo ritornare f. così cosa fa?:
  %search(Result, NewBound, G, ActualNode, Path, Actions).


% raggiunto quando il bound non è da aggiornare
search(Result,Bound,G,Node,Path,[Action|Actions]):-
  applicabile(Action, Node),
  trasforma(Action, Node, NewNode),
  \+member(NewNode, Path), % controlla di non esserci già passato
  heuristic(H, Node),
  G+H =< Bound,
  heuristic(NewH, NewNode),
  New_G is G+1,
  F is New_G+NewH,
  search(Result,Bound, New_G, NewNode,[NewNode|Path], Actions),!.
