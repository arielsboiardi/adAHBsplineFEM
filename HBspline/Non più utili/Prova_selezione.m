clear all; close all; clc
%% Costruisco spazio
p=3;
Xi=0:0.2:1;

space=Bspline_space(p,Xi);
hspace=HBspline_space(space);

space.plot_base

%% Selezione funzioni da raffianare
marked_cell=[1];
marked_fun=space.get_basis_functions(marked_cell);

%% Trova i nodi su cui esse insistono
marked_knots=space.get_knots(marked_fun);
space.knots(marked_knots);

%% Prova raffinamento 
hspace=hspace.refine(marked_fun)
hspace.plot_base