ida_star(Path, Actions):- %cose che devono esssere istanziate
  iniziale(Start),
  heuristic(Bound, Start),
  nb_setval(global_bound, Bound),
  ida_star_rec(Result, 0, Start, [Start], Actions).

% forse Result non serve: ho finito quando le azioni sono vuote e sono in finale
ida_star_rec(_,_,ActualNode,_,[]) :-
  finale(ActualNode).

ida_star_rec(Result, G, ActualNode, Path, Actions) :-
	nb_getval(global_bound, Bound),
  nb_setval(minF, inf),
	search(Result, Bound, G, ActualNode, Path, Actions),!.

% aggiungere altro ida_star_rec che aggiorna il bound a minF
ida_star_rec(Result, G, ActualNode, Path, Actions) :-
    nb_getval(minF, NewBound),
    nb_setval(global_bound, NewBound),
    nb_setval(minF, inf),
    search(Result, NewBound, G, ActualNode, Path, Actions),!.


/*
VARI CASI DI SEARCH:
1) soluz trovata
2) superiamo bound ma abbiamo ancora azioni da provare
3) superiamo il bound ma non abbiamo più azioni da provare
4) non superiamo il bound.
Continuare da sotto.
*/



% soluzione trovata
search(_,_,_,ActualNode,_,[]) :-
  finale(ActualNode).

% F supera il bound
search(Result, Bound, G, ActualNode, Path, Actions) :-
  heuristic(H, ActualNode),
  F is H+G,
  F > Bound,
  nb_getval(minF, FOld),
  FOld>F,
  nb_setval(minF, F),
  false.
  % devo ritornare f. così cosa fa?:
  %search(Result, NewBound, G, ActualNode, Path, Actions).

search(Result, Bound, G, ActualNode, Path, [Action|Actions]) :-
	applicabile(Action, ActualNode),
	trasforma(Action, ActualNode, NewNode),
	\+member(NewNode, Path),
	NewG is G+1,
  heuristic(NewH, NewNode),
  F is H+G,
  F<=Bound,
	search(Result, Bound, NewG, NewNode, [NewNode|Path], Actions),
	false.