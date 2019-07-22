% node -> state + F
% state -> state e basta (punto del path)

% IN FIND_NEW_OPENSET AGGIORNIAMO IL VALORE, MA IL PERCORSO SERVE?

% wrapper
a_star(Result) :-
  iniziale(InitialState),
  heuristic(F, InitialState),
  a_star_rec(Result, [node(InitialState,F,[])], [], 0, []).
  
% va in loop.
% dentro a result va messo (in scrittura) le azioni
% path resta vuoto
%ClosedSet non viene aggionrato: quando gli stati vanno inseriti lì dentro?

% Caso base
a_star_rec(Result, [node(State,_,Actions)|_], _, _, _) :-
  finale(State),
  Result = Actions.
  
a_star_rec(Result, [Node|OpenSet], ClosedSet, G, Path) :-
  [Node|OpenSet] \== [],
  % estrapolo F
  node(State,F,Actions) = Node,
  findall(Action,applicabile(Action,State),ApplicableList),
  findNewStates(NewNodes, node(State,F,Actions), G+1, ApplicableList, ClosedSet),
  % se non sono membri li aggiungiamo
  findNewOpenSet([Node|OpenSet], [State-F|ClosedSet], NewNodes, NewOpenSet),
  % ordino i nodi all'interno di OpenSet in ordine crescente su f
  sort(2, @=<, NewOpenSet, OpenSetOrdered),!,
  a_star_rec(Result, OpenSetOrdered, [State-F|ClosedSet], G+1, Path).
    
% findNewStates()  mi permette di trovare tutti i nuovi stati in cui posso andare dopo aver applicato le azioni allo stato attuale
% Caso base
findNewStates(_, _, _, [], _).
    
findNewStates([node(NewState,NewF,NewAct)|NewNodes], node(State,F,Act), G, [Action|Actions], ClosedSet) :- % aggiorna la frontiera
  trasforma(Action, State, NewState),
  heuristic(NewH, NewState),
  NewF is G + NewH, % caso in cui ogni movimento costa 1
  append(Act, [Action], NewAct),
  % COSì G+1 
  checkClosedSet(node(NewState,NewF,NewAct), ClosedSet, NewClosedSet),
  findNewStates(NewNodes, node(State,F,Act), G, Actions, NewClosedSet).
  
% findNewOpenSet mi permette di aggiornare OpenSet in modo corretto: se incontro uno stato che è già presente all'interno di OpenSet, aggiorno la sua F nel caso quella trovata sia minore di quella presente in OpenSet
% Caso in cui incontro uno stato nuovo
% OpenSet: insieme di stati aperti
% NewNodes: stati da inserire in OpenSet
% NewOpenSet: nuovo open set

% Caso base
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
% TOGLIERE (CIOè NON CONSIDERARE) QUALCOSA DA OPENSET? BASTA AGGIUNGERE ALTRO CASO
  
% Caso in cui lo stato sia già all'interno di OpenSet e il valore nuovo sia maggiore -> non faccio nulla
findNewOpenSet([node(State,V,_)|OpenSet], ClosedSet, [node(State,Value,_)|NewNodes], NewOpenSet) :-
  %getCurrentValue(V, State, OpenSet),
  member(State-_, ClosedSet),
  V =< Value,
  findNewOpenSet(OpenSet, ClosedSet, NewNodes, NewOpenSet).

findNewOpenSet([node(State,V,A)|OpenSet], ClosedSet, [node(State,Value,_)|NewNodes], [node(NewState,NewValue,NewAct)|NewOpenSet]) :-
  %getCurrentValue(V, State, OpenSet),
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

checkClosedSet(node(S,V,_), ClosedSet, NewClosedSet) :-
  member(S-F, ClosedSet),
  F>V,
  delete(ClosedSet, S-F, NewClosedSet).

checkClosedSet(_, ClosedSet, NewClosedSet) :-
  NewClosedSet = ClosedSet.