% wrapper
a_star(Result) :-
  iniziale(InitialState),
  heuristic(F, InitialState),
  a_star_rec(Result, [(InitialState,F)], [], 0, []).
  
% Caso base
a_star_rec(Result, [(State,F)|OpenSet], ClosedSet, G, Path) :-
  finale(State),
  Result = Path.
  
% Caso in cui incontro uno stato chiuso: non lo considero e vado avanti nella mia ricorsione
a_star_rec(Result, [(State,F)|OpenSet], ClosedSet, G, Path) :-
  member(State, ClosedSet),
  a_star_rec(Result, OpenSet, ClosedSet, G, Path).
  
a_star_rec(Result, [(State,F)|OpenSet], ClosedSet, G, Path) :-
    % trovare tutti i possibili percorsi a partire da State e poi fare ricorsione con argomenti aggiornati
    findall(Action,applicabile(Action,State),ApplicableList),
    findNewStates(NewNodes, State, G, ApplicableList),
    NewOpenSet is [NewNodes|OpenSet],
    % ordino i nodi all'interno di OpenSet in ordine crescente su f
    sort(2, @<, NewOpenSet, NewOpenSetOrdered),
    % SE UNO STATO è GIà IN OPENSET BISOGNA METTERLO UNA VOLTA SOLA CON LA F PIù PICCOLA
    a_star_rec(Result, NewOpenSetOrdered, [(State,F)|ClosedSet], Path).
    
% findNewStates()  mi permette di trovare tutti i nuovi stati in cui posso andare dopo aver applicato le azioni allo stato attuale
% Caso base
findNewStates(_, _, _, []).
    
findNewStates(NewNodes, ActualState, G, [Action|Actions]) :-
  trasforma(ActualState, Action, NewState),
  heuristic(NewH, NewState),
  NewF is G + NewH + 1, % caso in cui ogni movimento costa 1
  findNewStates([(NewState, NewF)|NewNodes], ActualState, Actions).
  
% PER INSERIRE DENTRO A OPENSET GUARDA http://www.swi-prolog.org/pldoc/doc_for?object=sort/4 PER ORDINARLI SENZA ELIMINARE I DUPLICATI
%sort(2,@<,[(c,2),(f,1),(m,6)],Result).
%Result = [(f, 1),  (c, 2),  (m, 6)].
% e aggiungi:
% heuristic(H, State),
%  F = G + H,


















