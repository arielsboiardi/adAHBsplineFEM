function u=HBspline_appr(hspace, uh, t)
% HBspline_appr calcola in t la funzione u che si scrive con coordinate uh
% rispetto alla base dello spazio gerarchico hspace.
%
%
%
% INPUTS:
%
%   hspace:     Bspline_space
%   uh:         coordinate della funzione u rispetto allo spazio hspace
%   t:          punto in cui valutare la funzione u
%
% OUTPUTS:
%
%   u:          valore della funzione risultante in t
%

if numel(uh)~=hspace.dim
    % Faccio un breve controllo sulla compatibilità basilare dei dati
    % forniti
    error('Dimensione dello spazio non compatibile con le cooridnate date')
end

L=hspace.nlev;
u=0;
jdx=2;
for l=1:L
    spacel=hspace.sp_lev{l};
    for adx=find(hspace.A{l})
        if adx==1
            u=u+uh(1)*spacel.Bspline_eval(adx,t);
        elseif adx==spacel.dim
            u=u+uh(hspace.dim)*spacel.Bspline_eval(adx,t);
        else
            u=u+uh(jdx)*spacel.Bspline_eval(adx,t);
            jdx=jdx+1;
        end
    end
end

end