:- initialization main.

main :- consult(['././ida_star/ida_star.pl']),
  consult(['././ida_star/../azioni.pl']),
  consult(['././ida_star/../data/labirinto_easy.pl']),
  consult(['././ida_star/../heuristics/manhattan_distance.pl']),
  ida_star(X, Y),
  atomic_list_concat(Y, ', ', A),
  atom_string(A, S),
  format("Solution = "),
  format(S),
  format(".\n"),
  halt.

main :- format("Solution = "),
  format("false.\n"),
  halt.
