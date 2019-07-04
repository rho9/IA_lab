ida_star(Path, Actions):- %cose che devono esssere istanziate
  iniziale(Start),
  heuristic(H, Start),
  ida_star_rec(Result,H, 0, Start, [Start], Actions).

ida_star_rec(-1,_,_,_,_,_).

ida_star_rec(Result, Bound, G, Node, Path, Actions):-
  nb_setval(minF, inf),!, %svuoto lo stack del backtraking
  search(Result,Bound,G, Node, Path,Actions),
  nb_getval(minF, Min),
  ida_star_rec(Result, Min, G, Node, Path, Actions).

search(_,Bound, G, Node, _, _) :-
  heuristic(H, Node),
  G+H > Bound,
  nb_getval(minF, Min),
  Min > G+H,
  nb_setval(minF, G+H),
  false.
  %se backtracking finito.

search(Result,_,_,Node,_,_):-
  finale(Node),
  Result is -1.

search(Result,Bound,G,Node,Path,[Action|Actions]):-
  applicabile(Action, Node),
  trasforma(Action, Node, NewNode),
  \+member(NewNode, Path),
  heuristic(H, Node),
  G+H =< Bound,
  search(Result,Bound, G+1, NewNode,[NewNode|Path], Actions).