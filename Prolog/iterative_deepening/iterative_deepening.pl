%wrapper per la chiamata da parte dell'utente
iterative_deepening(Soluzione, Max) :-
  iniziale(S),
  iterative_deepening_rec(S, Soluzione, 1, Max).

%caso base
iterative_deepening_rec(S, _, _, _) :-
  finale(S).

%cerca la soluzione entro la soglia data
iterative_deepening_rec(S, Soluzione, Soglia, Max) :-
  Soglia=<Max,
  dfs_aux(S, Soluzione, [S], Soglia).

%scende di un livello e fa la chiamata ricorsiva
iterative_deepening_rec(S, Soluzione, Soglia, Max) :-
  Soglia<Max,
  NuovaSoglia is Soglia +1,
  iterative_deepening_rec(S, Soluzione, NuovaSoglia, Max).

dfs_aux(S,[],_,_) :-
  finale(S).

dfs_aux(S,[Azione|AzioniTail],Visitati,Soglia) :-
  Soglia>0,
  applicabile(Azione,S),
  trasforma(Azione,S,SNuovo),
  \+member(SNuovo,Visitati),
  NuovaSoglia is Soglia-1,
  dfs_aux(SNuovo,AzioniTail,[SNuovo|Visitati],NuovaSoglia).