%%%%%%%%%%%%
% IDA STAR %
%%%%%%%%%%%%


% ida_star(Actions)
% Actions: actions from initial to final node
ida_star(Actions, ActionCost):-
  iniziale(Start),
  heuristic(H, Start),
  ida_star_rec(_, H, 0, Start, [Start], Actions, ActionCost).


% ida_star_rec(Result, Bound, G, Node, Path, Actions)
% Result: variable not assigned until the final node is reached
% Bound: actual bound
% G: cost to reach Node from initial node
% Node: actual node
% Path: list of nodes from initial node to Node
% Actions: list of actions that bring from initial node to Node
ida_star_rec(Result,  _, _, _, _, _, _):-
  nonvar(Result), !. % True if Result is not a free variable.

% search rule fails. If minF has infinite as value, no solutions is possible
ida_star_rec(Result, Bound, G, Node, Path, Actions, ActionCost):-
  nb_setval(minF, inf), % minF: global variable in which is saved the best bound (the best F)
  \+search(Result, Bound, G, Node, Path, Actions, ActionCost),
  nb_getval(minF, Min),
  Min \== inf,
  ida_star_rec(Result, Min, G, Node, Path, Actions, ActionCost).

ida_star_rec(Result, Bound, G, Node, Path, Actions, ActionCost):-
  search(Result, Bound, G, Node, Path, Actions, ActionCost),
  ida_star_rec(Result, Bound, G, Node, Path, Actions, ActionCost).


% search(Result, Bound, G, Node, Path, Actions)
% Result: variable not assigned until the final node is reached
% Bound: actual bound
% G: cost to reach Node from initial node
% Node: actual node
% Path: list of nodes from initial node to Node
% Actions: list of actions that bring from initial node to Node
search(Result, _, _, Node, _, Actions, _):-
  finale(Node),
  finale(Result),
  Actions = []. % avoid that a free variable is added to the solution

% the bound must be updated
search(_, Bound, G, Node, _, _, _) :-
  heuristic(H, Node),
  G+H > Bound,
  nb_getval(minF, Min),
  Min > G+H,
  nb_setval(minF, G+H),
  false.

% the bound must not be updated
search(Result, Bound, G, Node, Path, [Action|Actions], ActionCost):-
  heuristic(H, Node),
  G+H =< Bound,
  applicabile(Action, Node),
  trasforma(Action, Node, NewNode),
  \+member(NewNode, Path),
  New_G is G+ActionCost,
  search(Result, Bound, New_G, NewNode, [NewNode|Path], Actions, ActionCost), !.