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
%   1. La funzione non è forse necessaria, ma rende più immediato e
%   controllato l'accesso ai nodi di supporto.
%   2. Come in molte altre circostanze si è adottata l'indicizzazione
%   logica. Un spiegazione è data nella descrizione della classe
%   HBspline_space.
%   Osserviamo che forse inq uesto caso l'indicizzazione logica rappresenta
%   una complicazione, ma la manteniamo per una migliore interfaccia con le
%   altre functions.

p=space.deg;    % estraggo il grado
if ~islogical(fun_ind)
    % Converto in logici gli indici qualora siamo forniti indici
    % sequenziali.
    fun_ind=ismember(1:space.dim,fun_ind);
end

fun_ind=[fun_ind,false(1,p+1)];
% Le B-spline di base arrivano al penultimo nodo interno al dominio (senza
% contare il padding), per rappresentare con indici logici tutti i nodi
% serve aggiungere gli indici degli ultimi p+1 nodi.
sup_knots=fun_ind;
for pdx=1:p+1
    sup_knots=sup_knots | circshift(fun_ind,pdx);
    % Poiché l'indice di una B-spline coincide con l'indice del primo nodo
    % che essa tocca (a sx), complessivamente essa il primo nodo e p nodi
    % avanti, quindi si tratta di aggiungere agli i indici gli indici dei p
    % nodi successivi. 
end
end