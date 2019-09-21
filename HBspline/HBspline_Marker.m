function marked_bsp=HBspline_Marker(hspace, marked_cells)
% HBspline_Marker trasporta la marcatura dalle celle alle B-spline dello
% spazio gerarchico hspace.
%
%   marked_bsp=HBspline_Marker(hspace, marked_cells)
%
% INPUTS:
%
%   hspace:     HBspline_space con le informazio dello spazio gerarchico
%   marked_cells:   celle marcate come previsto dalla classe marker_out
%
% OUTPUTS:
%
%   marked_bsp: indici logici delle B-splines marcate
%

L=hspace.nlev; % ultimo livello disponibile dello spazio
spaceL=hspace.sp_lev{L};

marked_bsp=spaceL.get_basis_functions(marked_cells.ind);

end
