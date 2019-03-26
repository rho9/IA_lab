% creiamo un dfs con profondità limitata

% dfs_aux(Stato, ListaAzioni, Visitati, Soglia)

iterative_deepening(Soluzione, Max) :-
  iniziale(S),
  iterative_deepening_rec(S, Soluzione, 1, Max).


iterative_deepening_rec(S, _, _, _) :-
  finale(S).

iterative_deepening_rec(S, Soluzione, Soglia, Max) :-
  Soglia=<Max,
  \+dfs_aux(S, Soluzione, [S], Soglia),
  NuovaSoglia is Soglia +1,
  iterative_deepening_rec(S, Soluzione, NuovaSoglia, Max).

iterative_deepening_rec(S, Soluzione, Soglia, Max) :-
  Soglia=<Max,
  dfs_aux(S, Soluzione, [S], Soglia).

depth_limit_search(S, Soluzione,Soglia) :-
  iniziale(S),
  dfs_aux(S,Soluzione,[S],Soglia).


dfs_aux(S,[],_,_) :-
  finale(S).

dfs_aux(S,[Azione|AzioniTail],Visitati,Soglia) :-
  Soglia>0,
  applicabile(Azione,S),
  trasforma(Azione,S,SNuovo),
  \+member(SNuovo,Visitati),
  NuovaSoglia is Soglia-1,
  dfs_aux(SNuovo,AzioniTail,[SNuovo|Visitati],NuovaSoglia).

% se passi la soglia ti restituisce false. Ma me lo dice perché ho passato la soglia o perché non c'è soluzione?
