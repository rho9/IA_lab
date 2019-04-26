heuristic(H, pos(X, Y)) :- 
    finale(pos(XF, YF)),
    H is sqrt((XF-X)**2+(YF-Y)*2).