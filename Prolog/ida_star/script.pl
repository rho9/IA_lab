:- initialization main.

main :- consult(['./ida_star/ida_star.pl']),
  consult(['./ida_star/../azioni.pl']),
  consult(['./ida_star/../data/labirinto_easy.pl']),
  consult(['./ida_star/../heuristics/chebyshev_distance.pl']),
  ida_star(X, 1),
  atomic_list_concat(X, ', ', A),
  atom_string(A, S),
  format("Solution = "),
  format(S),
  format(".\n"),
  halt.

main :- format("Solution = "),
  format("false.\n"),
  halt.
