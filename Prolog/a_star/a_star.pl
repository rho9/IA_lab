% node -> state + F
% state -> state e basta (punto del path)

% wrapper
a_star(Result) :-
  iniziale(InitialState),
  heuristic(F, InitialState),
  a_star_rec(Result, [InitialState-F], [], 0, []).
  
% Caso base
a_star_rec(Result, [State-_|_], _, _, Path) :-
  finale(State),
  Result = Path.
  
% Caso in cui incontro uno stato chiuso: non lo considero e vado avanti nella mia ricorsione
a_star_rec(Result, [State-_|OpenSet], ClosedSet, G, Path) :-
  member(State, ClosedSet),
  a_star_rec(Result, OpenSet, ClosedSet, G, Path).
  
a_star_rec(Result, [State-F|OpenSet], ClosedSet, G, Path) :-
  findall(Action,applicabile(Action,State),ApplicableList),
  findNewStates(NewNodes, State, G, ApplicableList),
  findNewOpenSet(OpenSet, NewNodes),
  % ordino i nodi all'interno di OpenSet in ordine crescente su f
  sort(2, @<, OpenSet, OpenSetOrdered),
  % SE UNO STATO è GIà IN OPENSET BISOGNA METTERLO UNA VOLTA SOLA CON LA F PIù PICCOLA
  a_star_rec(Result, OpenSetOrdered, [State-F|ClosedSet], Path).
    
% findNewStates()  mi permette di trovare tutti i nuovi stati in cui posso andare dopo aver applicato le azioni allo stato attuale
% Caso base
findNewStates(_, _, _, []).
    
findNewStates(NewNodes, ActualState, G, [Action|Actions]) :- % aggiorna la frontiera
  trasforma(Action, ActualState, NewState),
  heuristic(NewH, NewState),
  NewF is G + NewH + 1, % caso in cui ogni movimento costa 1
  findNewStates([NewState-NewF|NewNodes], ActualState, G+1, Actions).
  
% findNewOpenSet mi permette di aggiornare OpenSet in modo corretto: se incontro uno stato che è già presente all'interno di OpenSet, aggiorno la sua F nel caso quella trovata sia minore di quella presente in OpenSet
% Caso in cui incontro uno stato nuovo
findNewOpenSet(OpenSet, [State-Value|NewNodes]) :-
  pairsKeys(OpenSet, OpenSetState),
  \+member(State, OpenSetState),
  findNewOpenSet([State-Value|OpenSet], NewNodes).
  
% Caso in cui lo stato sia già all'interno di OpenSet e il valore sia maggiore -> non faccio nulla
findNewOpenSet(OpenSet, [State-Value|NewNodes]) :-
  getCurrentValue(V, State, OpenSet),
  V > Value,
  findNewOpenSet([State-V|OpenSet], NewNodes). % modifica lo state-value perchè c'è già ed è minore

findNewOpenSet(OpenSet, [_|NewNodes]) :-
  findNewOpenSet(OpenSet, NewNodes). % rimuovo lo state-value perchè c'è già ed è maggiore

getCurrentValue(Value, State, [S-V|_]) :-
  S == State,
  Value = V.

getCurrentValue(Value, State, [_|OpenSet]) :-
  getCurrentValue(Value, State, OpenSet).

pairsKeys([], _).

pairsKeys([State-_|Set], Result) :-
  pairsKeys(Set, [State|Result]).

















