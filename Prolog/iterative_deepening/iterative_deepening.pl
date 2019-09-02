%%%%%%%%%%%%%%%%%%%%%%%
% ITERATIVE DEEPENING %
%%%%%%%%%%%%%%%%%%%%%%%


% iterative_deepening: wrapper per la chiamata da parte dell'utente
% Soluzione: variabile al cui interno vengono salvate le azioni che portano dalla cella iniziale a quella finale
% Max: soglia oltre cui la ricerca non può andare
% ActionCost: costo di ogni azione
iterative_deepening(Soluzione, Max, ActionCost) :-
  iniziale(S),
  iterative_deepening_rec(S, Soluzione, 1, Max, ActionCost).


% iterative_deepening_rec(StatoAttuale, Soluzione, SogliaAttuale, SogliaMassima, ActionCost)
% caso base: è stata raggiunta la casella finale
iterative_deepening_rec(S, _, _, _, _) :-
  finale(S).

% la soluzione si trova ancora entro il limite della soglia attuale
iterative_deepening_rec(S, Soluzione, Soglia, Max, _) :-
  Soglia=<Max,
  dfs_aux(S, Soluzione, [S], Soglia).

% la soluzione non è ancora stata trovata, ma la soglia attuale è stata superata (dfs_aux è false)
iterative_deepening_rec(S, Soluzione, Soglia, Max, ActionCost) :-
  NuovaSoglia is Soglia + ActionCost,
  NuovaSoglia=<Max,
  iterative_deepening_rec(S, Soluzione, NuovaSoglia, Max, ActionCost).


% dfs_aux(StatoAttuale, Soluzione, StatiVisitati, SogliaAttuale)
% caso base: è stata raggiunta la casella finale
dfs_aux(S,[],_,_) :-
  finale(S).

% passo induttivo: si applicano delle mosse per cercare di raggiungere la casella finale
dfs_aux(S,[Azione|AzioniTail],Visitati,Soglia) :-
  Soglia>0,
  applicabile(Azione,S),
  trasforma(Azione,S,SNuovo),
  \+member(SNuovo,Visitati),
  NuovaSoglia is Soglia-1,
  dfs_aux(SNuovo,AzioniTail,[SNuovo|Visitati],NuovaSoglia).