ida_star(Path, Actions):- %cose che devono esssere istanziate
  iniziale(Start),
  heuristic(Bound, Start),
  ida_star_rec(Result, Bound, 0, Start, [Start], Actions).



ida_star_rec(_,_,_,ActualNode,_,[]) :-
  finale(ActualNode).


% raggiunto il nodo finale
search(_,_,_,ActualNode,_,[]):-
  finale(ActualNode).

% quando il bound è da aggiornare
search(_,Bound, G, ActualNode, _, _) :-
  heuristic(H, ActualNode),
  G+H > Bound,
  nb_getval(minF, Min),
  Min > G+H,
  nb_setval(minF, G+H),
  false.
  %se backtracking finito.

% raggiunto quando il bound non è da aggiornare
search(Result,Bound,G,ActualNode,Path,[Action|Actions]):-
  applicabile(Action, ActualNode),
  trasforma(Action, ActualNode, NewNode),
  \+member(NewNode, Path), % controlla di non esserci già passato
  heuristic(NewH, NewNode),
  New_G is G+1,
  F is New_G+NewH,
  F =< Bound,
  search(Result,Bound, New_G, NewNode,[NewNode|Path], Actions),!.
