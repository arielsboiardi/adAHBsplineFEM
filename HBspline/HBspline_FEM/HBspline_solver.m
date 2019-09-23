function [uh, Ah, Fh]=HBspline_solver(probdata, hspace,t)
% HBspline_solver calcola la soluzione del problema probdata approssimata
% nello spazio hspace.
%
%   [uh, Ah, Fh]=HBspline_solver(probdata, hspace,t)
%
% INPUTS: 
%   probdata:   problem_data_set con i dati del problema
%   hspace:     HBspline_space con i dati dello spazio di approssimazione
%   t:          FACOLTATIVO punto di valutazione della soluz. approssimata
%
% OUTPUTS:
%
%   uh:         coefficinti della soluzione approssimata in hspace , se
%               viene dato il punto di valutazione t, uh contiene la
%               soluzione approssimata in hspace valutata in t
%   Ah:         matrice di rigidezza del problema discretizzato
%   Fh:         vettore di carico del problema discretizzato
%

Ah=HBspline_Assembly_opt(hspace,probdata);
Fh=HBspline_load_opt(hspace,probdata);
uh=Ah\Fh;
uh=[probdata.u0; uh; probdata.uL];

if nargin==3
    uh=hspace.HBspline_appr(uh,t);
end

end
