function ddu=ddBspline_appr(space,coefs,t)
% Valuta la derivata 2 della funzione con coefficeinti coefs
% rispetto alla base di space

if numel(coefs)~=space.dim
    error('Controlla il numero di coefficienti')
end

ddu=0; % assegno

for idx=1:space.dim
    ddu=ddu+coefs(idx)*space.ddBspline_eval(idx,t);
end
end