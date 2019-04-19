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
  Min is inf,
  search(NewResult, Min, 0, H, Bound, S, Path, Visited, Res),
  ida_star_rec(NewResult, NewResult, S, Path, Visited).  

%perché altimenti se fallisce il dopo potrebbe rifare un'altro caso base
search(Result, _, _, F, Bound, _, _, _, NewResult) :-
  F > Bound,!,
  write(NewResult),
  write(" is "),
  write(F),
  write("\n"),
  NewResult is F.
  
search(Result, _, _, _, _, S, _, _, NewResult) :-
  finale(S),!,
  NewResult = -1. %found

search(Result, Min, G, _, Bound, S, [Action|Actions], Visited, NewResult) :-
  applicabile(Action,S),
  trasforma(Action,S,SNuovo),
  \+member(SNuovo,Visited),
  NewG is G + 1,
  heuristic(H, SNuovo),
  NewF is NewG + H,
  search(NewResult, Min, NewG, NewF, Bound, SNuovo, Actions, [SNuovo|Visited], Res),
  updateMin(Min, NewResult, NewMin),
  NewResult is NewMin.

updateMin(Min, Result, NewMin) :- 
  Min >= Result,!,
  NewMin is Result.

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