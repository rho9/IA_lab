% IDA*

%wrapper per la chiamata da parte dell'utente
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
  \+(Result == -1),
  Min = Result,
  assert(Min).
  % assert(Min, result)

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

/*
 path              current search path (acts like a stack)
 node              current node (last node in current path)
 g                 the cost to reach current node
 f                 estimated cost of the cheapest path (root..node..goal)
 h(node)           estimated cost of the cheapest path (node..goal)
 cost(node, succ)  step cost function
 is_goal(node)     goal test
 successors(node)  node expanding function, expand nodes ordered by g + h(node)
 ida_star(root)    return either NOT_FOUND or a pair with the best path and its cost
 
 procedure ida_star(root)
   bound := h(root)
   path := [root]
   loop
     t := search(path, 0, bound)
     if t = FOUND then return (path, bound)
     if t = ∞ then return NOT_FOUND
     bound := t
   end loop
 end procedure
 
 function search(path, g, bound)
   node := path.last
   f := g + h(node)
   if f > bound then return f
   if is_goal(node) then return FOUND
   min := ∞
   for succ in successors(node) do
     if succ not in path then
       path.push(succ)
       t := search(path, g + cost(node, succ), bound)
       if t = FOUND then return FOUND
       if t < min then min := t
       path.pop()
     end if
   end for
   return min
 end function*/