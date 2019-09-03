heuristic(H, pos(X, Y)) :- 
    finale(pos(XF, YF)),
    H is max(abs(XF-X),abs(YF-Y)).