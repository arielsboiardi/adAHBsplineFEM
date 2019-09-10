function B=Bspline_eval(space, idx, t)
% Valuta in t la idx-esima B-spline del Bspline_space space.
%
% La valutazione avviene mediante la ricorsione di Cox-De Boor
% contenuta nella libreria Bsplines salvata a parte per
% eventuale accesso indipendente dalla classe.

B=bspline(idx,space.deg,space.knots,t);

end