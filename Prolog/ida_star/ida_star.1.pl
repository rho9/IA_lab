ida_star(Path, Actions):- %cose che devono esssere istanziate
  iniziale(Start),
  heuristic(H, Start),
  ida_star_rec(Result, H, 0, Start, [Start], Actions).

ida_star_rec(Result,_,_,_,_,_):-
  nonvar(Result).
% raggiunto il nodo finale

ida_star_rec(Result, Bound, G, Node, Path, Actions):-
  nb_setval(minF, inf),
  \+search(Result, Bound, G, Node, Path, Actions),
  nb_getval(minF, Min),
  ida_star_rec(Result, Min, G, Node, Path, Actions).

ida_star_rec(Result, Bound, G, Node, Path, Actions):-
  search(Result, Bound, G, Node, Path, Actions),
  ida_star_rec(Result, Bound, G, Node, Path, Actions).


search(Result,_,_,Node,_,Actions):-
  finale(Node),
  finale(Result).

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
  heuristic(H, Node),
  G+H =< Bound,
  applicabile(Action, Node),
  trasforma(Action, Node, NewNode),
  \+member(NewNode, Path), % controlla di non esserci già passato
  heuristic(NewH, NewNode),
  New_G is G+1,
  F is New_G+NewH,
  search(Result,Bound, New_G, NewNode,[NewNode|Path], Actions),!.
