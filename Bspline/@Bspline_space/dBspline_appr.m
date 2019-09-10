function du=dBspline_appr(space,coefs,t)
% Valuta la derivata della funzione con coefficeinti coefs
% rispetto alla base di space

if numel(coefs)~=space.dim
    error('Controlla il numero di coefficienti')
end

du=0; % assegno

for idx=1:space.dim
    du=du+coefs(idx)*space.dBspline_eval(idx,t);
end
end