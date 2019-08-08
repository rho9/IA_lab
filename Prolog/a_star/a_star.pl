%%%%%%%%%%
% A STAR %
%%%%%%%%%%


% a_star(Result, ActionCost)
% Result: actions from initial to final node
% ActionCost: cost of every action
a_star(Result, ActionCost) :-
  iniziale(InitialState),
  heuristic(H, InitialState),
  F is H+0,
  a_star_rec(Result, [node(InitialState,F,[])], [], 0, ActionCost).


% a_star_rec(Result, Openset, ClosedSet, G, ActionCost)
% Result: actions from initial to final node
% Openset: nodes that must be visited. Each element of Openset has this structure: node(State, F, ActionsToState)
% ClosedSet: nodes that can't be visited anymore 
% G: cost to reach actual node from initial node
% ActionCost: cost of every action
a_star_rec(Result, [node(State,_,Actions)|_], _, _, _) :-
  finale(State),
  Result = Actions.

% try to find a solution for the labyrinth
a_star_rec(Result, [Node|OpenSet], ClosedSet, G, ActionCost) :-
  [Node|OpenSet] \== [], % check if OpenSet is not empty.
  node(State, F, Actions) = Node,
  findall(Action, applicabile(Action,State), ApplicableList),
  findNewStates(NewNodes, node(State,F,Actions), G+ActionCost, ApplicableList, ClosedSet),
  findNewOpenSet([Node|OpenSet], [State-F|ClosedSet], NewNodes, NewOpenSet),
  % NewOpenSet is ordered on F (in this way it is taken always the lowest F)
  sort(2, @=<, NewOpenSet, OpenSetOrdered),!,
  a_star_rec(Result, OpenSetOrdered, [State-F|ClosedSet], G+ActionCost, ActionCost).


% findNewStates(NewNodes, ActualState, G, ApplicableList, CLosedSet)
% NewNodes: contains nodes reachable from ActualState that can be removed from ClosedSet
% find reachable states of ActualState and update ClosedSet
findNewStates(_, _, _, [], _).

findNewStates([node(NewState,NewF,NewAct)|NewNodes], node(State,F,Act), G, [Action|Actions], ClosedSet) :-
  trasforma(Action, State, NewState),
  heuristic(NewH, NewState),
  NewF is G + NewH,
  append(Act, [Action], NewAct),
  updateClosedSet(node(NewState,NewF,NewAct), ClosedSet, NewClosedSet),
  findNewStates(NewNodes, node(State,F,Act), G, Actions, NewClosedSet).


%se incontro uno stato che è già presente all'interno di OpenSet, aggiorno la sua F nel caso quella 
%trovata sia minore di quella presente in OpenSet
% Caso in cui incontro uno stato nuovo

% findNewOpenSet(OpenSet, ClosedSet, NewNodes, NewOpenSet)
% NewNodes: nodes that should be inserted into Openset
findNewOpenSet([], _, [], []).

findNewOpenSet([], ClosedSet, [node(State,_,_)|NewNodes], NewOpenSet) :-
  member(State-_, ClosedSet),
  findNewOpenSet([], ClosedSet, NewNodes, NewOpenSet).

findNewOpenSet([], ClosedSet, [node(State,Value,Actions)|NewNodes], [node(NewState,NewValue,NewAct)|NewOpenSet]) :-
  \+member(State-_, ClosedSet),
  NewState = State,
  NewValue = Value,
  NewAct = Actions,
  findNewOpenSet([], ClosedSet, NewNodes, NewOpenSet).

findNewOpenSet([node(State,_,_)|OpenSet], ClosedSet, [], NewOpenSet) :-
  member(State-_, ClosedSet),
  findNewOpenSet(OpenSet, ClosedSet, [], NewOpenSet).

findNewOpenSet([node(State,Value,Actions)|OpenSet], ClosedSet, [], [node(NewState,NewValue,NewAct)|NewOpenSet]) :-
  \+member(State-_, ClosedSet),
  NewState = State,
  NewValue = Value,
  NewAct = Actions,
  findNewOpenSet(OpenSet, ClosedSet, [], NewOpenSet).
  
% Caso in cui lo stato sia già all'interno di OpenSet e il valore nuovo sia maggiore -> non faccio nulla
findNewOpenSet([node(State,V,_)|OpenSet], ClosedSet, [node(State,Value,_)|NewNodes], NewOpenSet) :-
  member(State-_, ClosedSet),
  V =< Value,
  findNewOpenSet(OpenSet, ClosedSet, NewNodes, NewOpenSet).

findNewOpenSet([node(State,V,A)|OpenSet], ClosedSet, [node(State,Value,_)|NewNodes], [node(NewState,NewValue,NewAct)|NewOpenSet]) :-
  \+member(State-_, ClosedSet),
  V =< Value,
  NewState = State,
  NewValue = V,
  NewAct = A,
  findNewOpenSet(OpenSet, ClosedSet, NewNodes, NewOpenSet).

% Caso in cui lo stato sia già all'interno di OpenSet e il valore sia minore -> aggiorno il valore
findNewOpenSet([node(State,_,_)|OpenSet], ClosedSet, [node(State,_,_)|NewNodes], NewOpenSet) :-
  member(State-_, ClosedSet),
  findNewOpenSet(OpenSet, ClosedSet, NewNodes, NewOpenSet).

findNewOpenSet([node(State,_,_)|OpenSet], ClosedSet, [node(State,Value,Actions)|NewNodes], [node(NewState,NewValue, NewAct)|NewOpenSet]) :-
  \+member(State-_, ClosedSet),
  NewState = State,
  NewValue = Value,
  NewAct = Actions,
  findNewOpenSet(OpenSet, ClosedSet, NewNodes, NewOpenSet).

% Caso in cui debba aggiungere da OpenSet
findNewOpenSet([node(S,_,_)|OpenSet], ClosedSet, [node(State,Value,Actions)|NewNodes], NewOpenSet) :-
  S \= State, % vedere se si può togliere
  member(S-_, ClosedSet),
  findNewOpenSet(OpenSet, ClosedSet, [node(State,Value, Actions)|NewNodes], NewOpenSet).

findNewOpenSet([node(S,V,A)|OpenSet], ClosedSet, [node(State,Value,Actions)|NewNodes], [node(NewState,NewValue,NewAct)|NewOpenSet]) :-
  S \= State, % vedere se si può togliere
  \+member(S-_, ClosedSet),
  NewState = S,
  NewValue = V,
  NewAct = A,
  findNewOpenSet(OpenSet, ClosedSet, [node(State,Value,Actions)|NewNodes], NewOpenSet).

% Caso in cui debba aggiungere da NewNodes
findNewOpenSet([node(S,_)|OpenSet], ClosedSet, [node(State,_)|NewNodes], NewOpenSet) :-
  S \= State, % vedere se si può togliere  
  member(State-_, ClosedSet),
  findNewOpenSet(OpenSet, ClosedSet, NewNodes, NewOpenSet).

findNewOpenSet([node(S,V,A)|OpenSet], ClosedSet, [node(State,Value,Actions)|NewNodes], [node(NewState,NewValue,NewAct)|NewOpenSet]) :-
  S \= State, % vedere se si può togliere
  \+member(State-_, ClosedSet),
  NewState = State,
  NewValue = Value,
  NewAct = Actions,
  findNewOpenSet([node(S,V,A)|OpenSet], ClosedSet, NewNodes, NewOpenSet).


% updateClosedSet(Node, ClosedSet, NewClosedSet)
% Node structure: node(State, F, ActionsToState)
updateClosedSet(node(State,OldF,_), ClosedSet, NewClosedSet) :-
  member(State-NewF, ClosedSet),
  NewF>OldF,
  delete(ClosedSet, State-NewF, NewClosedSet).

updateClosedSet(_, ClosedSet, NewClosedSet) :-
  NewClosedSet = ClosedSet.