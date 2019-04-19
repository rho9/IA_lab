% IDA*

% wrapper per la chiamata da parte dell'utente
ida_star(Result, Path) :-
  iniziale(S),
  heuristic(H, S),
  ida_star_rec(Result, H, S, Path, [S]).

ida_star_rec(_, _, S, [], _) :- %caso base
  finale(S),
  format("Found").

ida_star_rec(Result, _, _, _, _) :- %caso base
  Result == inf,
  format("Not found").

ida_star_rec(Result, Bound, S, Path, Visited) :-
  heuristic(H, S),!,
  search(Result, 0, H, Bound, S, Path, Visited),
  ida_star_rec(Result, Result, S, Path, Visited).  

%perché altimenti se fallisce il dopo potrebbe rifare un'altro caso base
search(Result, _, F, Bound, _, _, _) :-
  F > Bound,!,
  Result = F.
  
search(Result, _, _, _, S, _, _) :-
  finale(S),!,
  Result = -1. %found

search(Result, G, _, Bound, S, [Action|Actions], Visited) :-
  Min = inf,
  applicabile(Action,S),
  trasforma(Action,S,SNuovo),
  \+member(SNuovo,Visited),
  NewG is G + 1,
  heuristic(H, SNuovo),
  NewF is NewG + H,
  search(Result, NewG, NewF, Bound, SNuovo, Actions, [SNuovo|Visited]),
  updateMin(Min, Result).

updateMin(Min, Result) :- 
  format("ciao1"),
  \+(Result == -1),
  format("ciao2"),!,
  format("ciao3"),
  Min is Result,
  format("ciao4"),
  assert(Min).

/*% caso base (non c'è soluzione, tutte le euristiche sono peggiori di quella di partenza)
search([ActualNode|Path], G, Bound, Result) :-
  heuristic(H, ActualNode),
  F is G + H,
  F > Bound,
  Result is F.
  
% caso base (il nodo che sto considerando è finale)
search([ActualNode|Patsh], G, Bound, Result) :-
  finale(ActualNode),
  Result is -1.
  
search([ActualNode|Path], G, Bound, Result) :-
  heuristic(H, ActualNode),
  F is G + H,
  F =< Bound, % facciamo il controllo per non avere problemi con il backtracking
  \+finale(ActualNode),
  Min is inf, % ci si augura che funzioni
 */ 