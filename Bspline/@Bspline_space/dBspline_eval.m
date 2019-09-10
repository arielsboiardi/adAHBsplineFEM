function dB=dBspline_eval(space, idx, t)
% Valuta in t la derivata della idx-esima B-spline del
% Bspline_space space.

dB=dbspline(idx,space.deg,space.knots,t);

end