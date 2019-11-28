:- initialization main.

main :- consult(['././iterative_deepening/iterative_deepening.pl']),
  consult(['././iterative_deepening/../azioni.pl']),
  consult(['././iterative_deepening/../data/labirinto_no_sol_10.pl']),
  consult(['././iterative_deepening/../heuristics/manhattan_distance.pl']),
  iterative_deepening(X, 15, 1),
  atomic_list_concat(X, ', ', A),
  atom_string(A, S),
  format("Solution = "),
  format(S),
  format(".\n"),
  halt.

main :- format("Solution = "),
  format("false.\n"),
  halt.
