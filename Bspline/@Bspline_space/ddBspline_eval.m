function ddB=ddBspline_eval(space, idx, t)
% Valuta in t la derivata seconda della idx-esima B-spline del
% Bspline_space space.

ddB=ddbspline(idx,space.deg,space.knots,t);

end