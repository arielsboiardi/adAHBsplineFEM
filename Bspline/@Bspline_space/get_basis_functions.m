function bfun_ind=get_basis_functions(space,cell_ind)
% get_basis_functions determina gli indici delle B-splines di space che non
% si annullano sulle celle della griglia identificate da cell_ind.
%
%   bfun_ind=get_basis_functions(space,cell_ind)
%
% INPUTS:
%
%   space:      Bspline_space contente le informazioni dello spazio
%   cell_ind:   indici delle celle delle griglia di space su cui hanno
%               supporto le funzioni cercate. Gli indici possono essere
%               dati sia numericame che come vettore logico di dimensione
%               numel(space.knots)-1 con true per le celle cercte e false
%               altrimenti, come risulta dalle funzioni di marcatura in
%               marked.ind
%
% OUTPUTS:
%
%   bfun_ind:   vettore logico di dimensione space.dim contnte la lista
%               delle funzioni di base che hanno sipporto sulle celle
%               indicate in cell_ind.
%

if islogical(cell_ind)
    cell_ind=cell_ind(1:space.dim);
else
    % Se non ho a che fare con un vettore logico lo converto in logico.
    % Questa scelta è stata fatta avendo in mente gli usi di questa
    % function. Le prima p celle vengono non contate perché è verosimi che
    % l'utente fornisca gli indici sequenziali delle celle visibili, non di
    % quelle del padding. 
    cell_ind=[false(1,space.deg),ismember(1:space.dim-space.deg,cell_ind)];
end

bfun_ind=cell_ind;
for pdx=1:space.deg
    % L'operazione esguita con valori booleani dovrebbe essere più veloce e
    % il risultato occupare meno memoria.
    bfun_ind = bfun_ind | [cell_ind(1+pdx:space.dim),false(1,pdx)];
%     bfun_ind = bfun_ind | circshift(cell_ind,-pdx);
end
end
