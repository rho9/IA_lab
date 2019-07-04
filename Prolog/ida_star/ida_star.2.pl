% IDA*

% wrapper per la chiamata da parte dell'utente
ida_star(Result) :-
  iniziale(S),
  heuristic(H, S),
  ida_star_rec(Result, H, S, [S], 0).

%ida_star_rec(-1, _, _, _, _) :- %caso base
  %finale(S),
  %format("Found").

%ida_star_rec(Result, S, Path, Visited, Bound) :- %caso base
  %Result == inf,
  %format("Not found").

ida_star_rec(Result, Bound, S, Visited, G) :-
  search(Result, Bound, S, Visited, G),
  findall(FNode, ida_node(_, FNode), Bounds),
  exclude(>=(Bound), Bounds, OverBounds),
  sort(OverBounds, SortedBounds),
  nth0(0, SortedBounds, NewBound),
  retractall(ida_node(_,_)),
  ida_star_rec(Result, NewBound, S, Visited, G).  %ResultSearch is the new Bound

%perché altimenti se fallisce il dopo potrebbe rifare un'altro caso base
search([], S, _, _) :-
  finale(S).

search([Action|Result], Bound, S, Visited, G) :-
  applicabile(Action,S),
  trasforma(Action,S,SNuovo),
  \+member(SNuovo,Visited),
  NewG is G + 1,
  heuristic(H, SNuovo),
  NewF is NewG + H,
  assert(ida_node(SNuovo, NewF)),
  NewF =< Bound,
  search(Result, Bound, SNuovo, [SNuovo|Visited], NewG).

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
