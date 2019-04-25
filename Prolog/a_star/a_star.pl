a_star(Result) :-
  iniziale(S),
  a_star_rec(Result, [S], [], 0, []).
  
a_star_rec(Result, [State|OpenSet], ClosedSet, G, Path) :-
  finale(State),
  Result = Path.
  
a_star_rec(Result, [State|OpenSet], ClosedSet, G, Path) :-
    % trovare tutti i possibili percorsi a partire da State e poi fare ricorsione con aargomenti aggiornati
    a_star_rec(Result, OpenSet [State|ClosedSet], )
  
% PER INSERIRE DENTRO A OPENSET GUARDA http://www.swi-prolog.org/pldoc/doc_for?object=sort/4 PER ORDINARLI SENZA ELIMINARE I DUPLICATI
% e aggiungi:
% heuristic(H, State),
%  F = G + H,