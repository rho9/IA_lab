bfs(Soluzione) :-
  iniziale(S),
  bfs_aux([nodo(S,[])],[S],Soluzione).
  
% bfs_aux(Coda,Visitati,Soluzione)
% Coda è una lista di nodi che contengono uno stato e le azioni che ho fatto per arrivare fino a lì
% Coda = [nodo[S,Azioni)|...]
bfs_aux([nodo[S,Azioni)|_],_,Azioni) :- finale(S).
bfs_aux([nodo[S,Azioni)|Tail],Visitati,Soluzione) :-
  findall(Azione,applicabile(Azione,S),ListaApplicabili), % mi restituisce tutte le azioni che posso fare
  generaFigli(nodo(S,Azioni),ListaApplicabili,Visitati,ListaFigli),
  append(Tail,ListaFigli,NuovaCoda),
  bfs_aux(NuovaCoda,[S|Visitati],Soluzione). % aggiungo un nodo a Visitati solo quando lo espando
  
generaFigli(_,[],_,[]).
generaFigli(nodo(S,Azioni),[Azione|AltreAzioni],Visitati,[nodo(SNuovo,[Azione|Azioni])|FigliTail]) :-
  trasforma(Azione,S,SNuovo),
  \+member(SNuovo,Visitati),
  generaFigli(nodo(S,Azioni),AltreAzioni,Visitati,FigliTail).
  
% manca però un caso: che succede se un figlio non viene generato perché è in Visitati? che mi fermo -> mi serve !