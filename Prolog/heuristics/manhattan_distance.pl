heuristic(H, pos(X, Y)) :- 
    finale(pos(XF, YF)),
    H is abs(XF-X) + abs(YF-Y).