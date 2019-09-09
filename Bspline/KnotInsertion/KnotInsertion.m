function refinedSpace=KnotInsertion(space, marked)
% KnotInsertion effettua raffinamento locale del Bspline_space mediante 
% knot-insertion in base alle informazioni in marked.
%
%   refinedSpace=KnotInsertion(space, marked)
%
% INPUTS:
%
%   space: Bspline_space con le informazioni dello spazio di
%   approssimazione
%   marked: marker_out con le informazioni sugli elementi marcati dalla
%   procedura generale di marcatura
%
% OUTPUTS: 
%
%   refinedSpace: Bsplie_space ottenuto dal raffinamento di space mediante
%   inserimento di nodi al centro degli internodi marcati
%

Xi=space.knots;     % nodi dello spazio
H=diff(Xi);         % ampiezza degli internodi

if iscolumn(Xi)
    % Siccome la costruzione successiva si basa in modo critico sula fatto
    % che il vettore di nodi sia una riga meglio controllare. Nel caso sia
    % un vettore colonna lo metto in riga!
    Xi=reshape(Xi, 1, []);
end
markedindcs=find(marked.ind);
for jdx=1:marked.numel
    kdx=markedindcs(jdx);
    h=Xi(kdx+1)-Xi(kdx);
    if h>0
        Xi=[Xi(1:kdx), Xi(kdx)+0.5*h, Xi(kdx+1:end)];
        markedindcs=markedindcs+1;
    end
end

% Siccome la costruzione della calsse Bspline_space aggiunge i nodi
% ripetuti in accordo con il grado, devo rimuovere i primi p e gli ultimi p
% nodi 
p=space.deg;
Xi=Xi(p+1:end-p);
refinedSpace=Bspline_space(space.deg,Xi);

end
