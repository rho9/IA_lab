%wrapper per la chiamata da parte dell'utente
ida_star(Soluzione) :-
  iniziale(S),
  heuristic(S, H),
  assert(min_h(inf)), %in questo modo il predicato viene salvato nel db
  assert(actual_g(0)),
  ida_star_rec(S, Soluzione, H, 0).


heuristic(S, H):-
  H is 1.

%caso base
ida_star_rec(S, _, _, _) :-
  finale(S).

%cerca la soluzione entro la soglia data
ida_star_rec(S, Soluzione, H, G) :-
  dfs_aux(S, Soluzione, [S], G+H).

%scende di un livello e fa la chiamata ricorsiva
ida_star_rec(S, Soluzione, Soglia, H, G) :-
  heuristic(S, H),
  NuovaSoglia is Soglia + H,
  ida_star_rec(S, Soluzione, NuovaSoglia).

dfs_aux(S,[],_,_) :-
  finale(S).

dfs_aux(S,[Azione|AzioniTail],Visitati,Soglia, G) :-
  heuristic(S, H),
  G + H =< Soglia,
  applicabile(Azione,S),
  trasforma(Azione,S,SNuovo),
  \+member(SNuovo,Visitati),
  G is G + 1,
  assert(actual_g(G)),
  assert(min_h(inf)),
  dfs_aux(SNuovo,AzioniTail,[SNuovo|Visitati],Soglia, G).

dfs_aux(S,[Azione|AzioniTail],Visitati,Soglia, G) :-
  heuristic(S, H),
  G + H > Soglia,
  min_h(X), %possibile problema OR +
  actual_g(G1),%frontiera
  G1 == G,
  X > G + H,
  assert(min_h(H)).
  %Soglia. % cose