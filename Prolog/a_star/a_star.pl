% node -> state + F
% state -> state e basta (punto del path)

% IN FIND_NEW_OPENSET AGGIORNIAMO IL VALORE, MA IL PERCORSO SERVE?

% wrapper
a_star(Result) :-
  iniziale(InitialState),
  heuristic(F, InitialState),
  a_star_rec(Result, [InitialState-F], [], 0, []).
  
% va in loop.
% dentro a result va messo (in scrittura) le azioni
% path resta vuoto
%ClosedSet non viene aggionrato: quando gli stati vanno inseriti lì dentro?

% Caso base
a_star_rec(Result, [State-_|_], _, _, Path) :-
  finale(State),
  Result = Path,
  print(Result).
  
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
  a_star_rec(Result, OpenSetOrdered, [State-F|ClosedSet], G+1, Path).
    
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
% OpenSet: insieme di stati aperti
% NewNodes: stati da inserire in OpenSet
% NewOpenSet: nuovo open set

% Caso base
findNewOpenSet([], [], _).

findNewOpenSet([], [State-Value|NewNodes], NewOpenSet) :-
  findNewOpenSet([], NewNodes, [State-Value|NewOpenSet]).

findNewOpenSet([State-Value|OpenSet], [], NewOpenSet) :-
  findNewOpenSet(OpenSet, [], [State-Value|NewOpenSet]).

% TOGLIERE (CIOè NON CONSIDERARE) QUALCOSA DA OPENSET? BASTA AGGIUNGERE ALTRO CASO
  
% Caso in cui lo stato sia già all'interno di OpenSet e il valore nuovo sia maggiore -> non faccio nulla
findNewOpenSet([State-V|OpenSet], [State-Value|NewNodes], NewOpenSet) :-
  %getCurrentValue(V, State, OpenSet),
  V =< Value,
  findNewOpenSet(OpenSet, NewNodes, [State-V|NewOpenSet]).

% Caso in cui lo stato sia già all'interno di OpenSet e il valore sia minore -> aggiorno il valore
findNewOpenSet([State-_|OpenSet], [State-Value|NewNodes], NewOpenSet) :-
  findNewOpenSet(OpenSet, NewNodes, [State-Value|NewOpenSet]).

% Caso in cui debba aggiungere da OpenSet
findNewOpenSet([S-V|OpenSet], [State-Value|NewNodes], NewOpenSet) :-
  member(State, OpenSet),
  S \= State, % vedere se si può togliere
  findNewOpenSet(OpenSet, [State-Value|NewNodes], [S-V|NewOpenSet]).

% Caso in cui debba aggiungere da NewNodes
findNewOpenSet([S-V|OpenSet], [State-Value|NewNodes], NewOpenSet) :-
  S \= State, % vedere se si può togliere
  findNewOpenSet([S-V|OpenSet], NewNodes, [State-Value|NewOpenSet]).

getCurrentValue(Value, State, [S-V|_]) :-
  S == State,
  Value = V.

getCurrentValue(Value, State, [_|OpenSet]) :-
  getCurrentValue(Value, State, OpenSet).

% estrae lo stato togliendo il valore (serve per usare member)
pairsKeys([], _).

pairsKeys([State-_|Set], [State|Result]) :-
  pairsKeys(Set, Result).

















