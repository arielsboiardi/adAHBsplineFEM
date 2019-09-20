function sup_cells=get_cells(space,fun_ind)
% get_knots determina gli indici delle celle che supportano la funzione di
% indice fun_ind dello spazio space.
%
%   supp_cells = get_knots(space,fun_ind)
%
% INPUTS:
%
%   space:      Bspline_space in cui sono le funzioni fun_ind
%   fun_ind:    indici sequenziali o logici delle B.splines di cui vogliamo
%               trovare le celle di supporto
%
% OUTPUTS:
%
%   supp_cells: vettore contente gli indici delle celle che supportano le
%               B-splines identificate degli indici fun_ind
%

p=space.deg;    % estraggo il grado
if ~islogical(fun_ind)
    % Converto in logici gli indici qualora siamo forniti indici
    % sequenziali.
    fun_ind=ismember(1:space.dim,fun_ind);
end

fun_ind=[fun_ind,false(1,p)];
% L'ultima B-spline della base ha indice parti all'indice dell'ultima
% cella, senza contare quelle del padding. Devo quindi aggiungere i
% successivi p indici.

sup_cells=fun_ind;
for pdx=1:p
    % L'indice di ogni B-spline coincide con l'indice della prima cella del
    % suo supporto, poiché ogni B-spline tocca p celle basta traslare gl
    % iindici attivi p volte:
    sup_cells = sup_cells | circshift(fun_ind,pdx);
end
end
