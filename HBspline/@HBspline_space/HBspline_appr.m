function u=HBspline_appr(hspace, uh, t, der_order)
% HBspline_appr calcola in t la funzione u che si scrive con coordinate uh
% rispetto alla base dello spazio gerarchico hspace. Se dato der_order
% viene valutata la derivata di ordine 1 o 2.
%
%   u=HBspline_appr(hspace, uh, t, der_order)
%
% INPUTS:
%
%   hspace:     Bspline_space
%   uh:         coordinate della funzione u rispetto allo spazio hspace
%   t:          punto in cui valutare la funzione u
%   der_order:  ordine di derivazione
%
% OUTPUTS:
%
%   u:          valore della funzione risultante in t
%

if numel(uh)~=hspace.dim
    % Faccio un breve controllo sulla compatibilità basilare dei dati
    % forniti
    error('Dimensione dello spazio non compatibile con le coordinate date')
end

if nargin<4
    % Se non viene specificato l'ordine di derivazione restituisce la
    % funzione non derivata.
    der_order=0;
end

% % In base all'ordine di derivazioen richiesto bisogna chiamare un diverso
% metodo della classe Bspline_space per la valutazione della B-spline:
% costruisco il nome del metodo in base all'ordine di derivazione
eval_method=strcat(repmat('d',1,der_order),'Bspline_eval');

L=hspace.nlev;
u=0;
jdx=2;
for l=1:L
    spacel=hspace.sp_lev{l};
    for adx=find(hspace.A{l})
        if adx==1
%             u=u+uh(1)*spacel.Bspline_eval(adx,t);
            u=u+uh(1)*feval(eval_method, spacel, adx, t);
        elseif adx==spacel.dim
            u=u+uh(hspace.dim)*feval(eval_method, spacel, adx, t);
        else
            u=u+uh(jdx)*feval(eval_method, spacel, adx, t);
            jdx=jdx+1;
        end
    end
end

end
