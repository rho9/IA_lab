ida_star(Path, Actions):- %cose che devono esssere istanziate
  iniziale(Start),
  heuristic(Bound, Start),
  nb_setval(global_bound, NewBound),
  ida_star_rec(Result, 0, Start, [Start], Actions).

% forse Result non serve: ho finito quando le azioni sono vuote e sono in finale
ida_star_rec(_,_,ActualNode,_,[]) :-
  finale(ActualNode).

ida_star_rec(Result, G, ActualNode, Path, Actions) :-
	nb_getval(global_bound, Bound),
	search(Result, Bound, G, ActualNode, Path, Actions).

% soluzione trovata
search(_,_,_,ActualNode,_,[]) :-
  finale(ActualNode).

% F supera il bound
search(Result, Bound, G, ActualNode, Path, Actions) :-
  heuristic(H, ActualNode),
  F is H+G,
  F > Bound,
  NewBound is F,
  nb_setval(global_bound, NewBound),
  false.
  % devo ritornare f. così cosa fa?:
  %search(Result, NewBound, G, ActualNode, Path, Actions).

search(Result, Bound, G, ActualNode, Path, [Action|Actions]) :-
	nb_setval(minF, inf),
	applicabile(Action, ActualNode),
	trasforma(Action, ActualNode, NewNode),
	\+member(NewNode, Path),
	NewG is G+1,
	search(Result, Bound, NewG, NewNode, [NewNode|Path], Actions),
	nb_getval(minF, Min),
	Bound < Min,
	nb_setval(minF, Bound),
	false.