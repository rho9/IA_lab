% node -> state + F
% state -> state e basta (punto del path)

% IN FIND_NEW_OPENSET AGGIORNIAMO IL VALORE, MA IL PERCORSO SERVE?

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
  
a_star_rec(Result, OpenSet, ClosedSet, G, Path) :-
  % estrapolo F
  [State-F|_] = OpenSet,
  %getCurrentValue(F, State),
  findall(Action,applicabile(Action,State),ApplicableList),
  findNewStates(NewNodes, State, G+1, ApplicableList),
  pairsKeys(OpenSet, States),
  % se non sono membri li aggiungiamo
  findNewOpenSet(OpenSet, NewNodes, States),
  % ordino i nodi all'interno di OpenSet in ordine crescente su f
  sort(2, @<, OpenSet, OpenSetOrdered),
  % SE UNO STATO è GIà IN OPENSET BISOGNA METTERLO UNA VOLTA SOLA CON LA F PIù PICCOLA
  a_star_rec(Result, OpenSetOrdered, [State-F|ClosedSet], Path).
    
% findNewStates()  mi permette di trovare tutti i nuovi stati in cui posso andare dopo aver applicato le azioni allo stato attuale
% Caso base
findNewStates(_, _, _, []).
    
findNewStates([NewState-NewF|NewNodes], ActualState, G, [Action|Actions]) :- % aggiorna la frontiera
  trasforma(Action, ActualState, NewState),
  heuristic(NewH, NewState),
  NewF is G + NewH, % caso in cui ogni movimento costa 1
  % COSì G+1 
  findNewStates(NewNodes, ActualState, G, Actions).
  
% findNewOpenSet mi permette di aggiornare OpenSet in modo corretto: se incontro uno stato che è già presente all'interno di OpenSet, aggiorno la sua F nel caso quella trovata sia minore di quella presente in OpenSet
% Caso in cui incontro uno stato nuovo
findNewOpenSet([State-Value|OpenSet], [State-Value|NewNodes], States) :-
  \+member(State, States),
  findNewOpenSet(OpenSet, NewNodes, [State|States]).
  
% Caso in cui lo stato sia già all'interno di OpenSet e il valore nuovo sia maggiore -> non faccio nulla
findNewOpenSet([State-V|OpenSet], [State-Value|NewNodes], States) :-
  %getCurrentValue(V, State, OpenSet),
  V =< Value,
  findNewOpenSet(OpenSet, NewNodes, States).

% Caso in cui lo stato sia già all'interno di OpenSet e il valore sia minore -> aggiorno il valore
findNewOpenSet([State-V|OpenSet], [State-Value|NewNodes], States) :-
  V is Value,
  findNewOpenSet(OpenSet, NewNodes, States).

getCurrentValue(Value, State, [S-V|_]) :-
  S == State,
  Value = V.

getCurrentValue(Value, State, [_|OpenSet]) :-
  getCurrentValue(Value, State, OpenSet).

% estrae lo stato togliendo il valore (serve per usare member)
pairsKeys([], _).

pairsKeys([State-_|Set], [State|Result]) :-
  pairsKeys(Set, Result).

















