function sup_knots=get_knots(space,fun_ind)
% get_knots determina gli indici dei nodi che supportano la funzione di
% indice fun_ind dello spazio space.
%
%   supp_knots=get_knots(space,fun_ind)
%
% INPUTS:
%
%   space:      Bspline_space in cui sono le funzioni fun_ind
%   fun_ind:    indici sequenziali o logici delle funzioni per cui vogliamo
%               trovare i nodi di supporto 
%
% OUTPUTS:
%
%   supp_knots: vettore contente gli indici dei nodi che supportano le
%               funzioni identificate degli indici fun_ind
%
%
% Note:
%   Come in molte altre circostanze si è adottata l'indicizzazione logica. 
%   Un spiegazione è data nella descrizione della classe HBspline_space.
%

p=space.deg;    % estraggo il grado
if ~islogical(fun_ind)
    % Converto in logici gli indici qualora siamo forniti indici
    % sequenziali.
    fun_ind=ismember(1:space.dim,fun_ind);
end

fun_ind=[fun_ind,false(1,p+1)];
% L'ultima B-spline della base ha indice parti all'indice del penultimo
% indice, senza contare quelli del padding. Devo quindi aggiungere i
% successivi p+1 indici.

sup_knots=fun_ind;
for pdx=1:p+1
    % L'indice di ogni B-spline coincide con l'indice del primo nodo su cui
    % essa ha supporto, pertanto i nodi di supporto sono i p+1 nodi
    % successivi al primo:
    sup_knots=sup_knots | circshift(fun_ind,pdx); 
end
end
