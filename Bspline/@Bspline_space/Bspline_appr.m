function u=Bspline_appr(space,coefs,t)
% Valuta la spline con coefficienti coefs rispetto alla base
% del Bspline_spase space in t.

if numel(coefs)~=space.dim
    error('Controlla il numero di coefficienti')
end

u=0; % assegno

for idx=1:space.dim
    u=u+coefs(idx)*space.Bspline_eval(idx,t);
end
end
