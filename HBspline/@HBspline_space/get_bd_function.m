function [fn_L, fn_ind]=get_bd_function(hspace, index)
% get_bd_function trova il livello L e l'indice fn_ind delle funzioni di
% bordo nello spazio gerarchico.
%
%   [L, fn_ind]=get_bd_function(hspace, index)
%
% INPUTS:
%
%   hspace: spazio gerarchico in cui cerchiamo 
%   index:  indice della funzione da cercare, in particolare:
%               - 1 per la prima B-spline (interpolante nel primo nodo)
%               - 'last' per l'ultima (interpolante in fondo al dominio)
%
% OUTPUTS:
%   
%   L:      livello in cui la funzione cercata è attiva
%   fn_ind: indice della funzione cercata all'interno del livello L.
%           Osserviamo che nel caso della prima fn_ind=1, per l'ultima
%           invece l'indice è da calcolare in ogni livello.
%

fn_ind=1;
last=false;
if strcmp(index,'last')
    last=true;
end

for fn_L=1:hspace.nlev     % scorro su tutti i livelli
    if last
        fn_ind=hspace.sp_lev{fn_L}.dim;
    end
    if hspace.A{fn_L}(fn_ind)   % è attiva la prima funzione del livello L
         return
    end
end
end
    
