function C=get_children(hspace,fun_ind)
% get_children determina gli indici delle B-spline della base di uno spazio
% ottenuto per raffinamento diadico dell'ultimo livello di hspace che sono
% figlie delle B-spline fun_ind dell'ultimo livello di hspace.
%
%   C=get_children(lev,fun_ind)
%
% INPUTS
%
%   hspace:     HBspline_space
%   fun_ind:    indici delle B-spline dell'ultimo livello di hspace di cui
%               si vogliono determinare le figlie 
%
% OUTPUTS:
%
%   C:          indici delle B-spline della base del livello ottenuto per 
%               raffinamento diadico dell'ultimo livello disponibile 
%
% Attenzione:   tutti i livelli sono ottenuti mediante raffinamento
% diadico, come stabilito dalle regole di raffinamento della classe
% Bspline_space e HBspline_space. La relazione fra i due livelli si può
% trovare in K. Hollig, Finite Element Methods with B-Splines, SIAM, 2003. 
%
% NOTE:
%
%   1. Non c'è un vero motivo per cui questa function sia un metodo di
%   HBspline_space se non la ocmodità nella notazione.
%   2. Questa operazione potrebbe anche essere svolta usando la matrice di
%   connettività, ma l'operazione non è afatto banale. 
%

p=hspace.deg;       % inizio leggendo il grado per velocità di accesso
if islogical(fun_ind) % rendo compatibile con indici logici
    fun_ind=find(fun_ind);
end

C=2*fun_ind;
C1=C;
for pdx=1:p+2
    C=union(C,C1+pdx-(p+2));
    % Rispetto alla formula della fonte citata ho dovuto traslare gli
    % indici di p+2. La traslazione di p indici è dovuta al fatto che nel
    % raffinamento non biseco i nodi ripetuti all'inizio e alla fine per
    % facilità di indicizzazione delle funzioni. La traslazione di 2 è
    % dovuta al fatto che ho indicizzato le funzioni da 1 e non da 0,
    % quindi devo tornare indietro di 2*(1-0).
end
end
