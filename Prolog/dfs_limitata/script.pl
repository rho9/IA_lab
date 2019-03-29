:- initialization main.

main :- consult(['././dfs_limitata/dfs_limitata.pl']),
  consult(['././dfs_limitata/../azioni.pl']),
  consult(['././dfs_limitata/../data/esempio9a.pl']),
  depth_limit_search(X, 30),
  atomic_list_concat(X, ', ', A),
  atom_string(A, S),
  format("Solution = "),  format(S),
  format(".\n"),
  halt.

main :- format("Solution = "),  format("false.\n"),
  halt.
