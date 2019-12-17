clear all; close all; clc
% addpath(genpath('.'))

%% Dati del problema
Problema_bd_layer_dx;
% Problema_bd_layer_sx;
% Problema_int_layer;
% Problema_sol_oscillante;
% Problema_sol_Heaviside_regolarizzata;


% Costruzione del problema
probdata=problem_data_set(Omega, b, m, u0, u1, f, uex);
t=probdata.Omega(1):0.001:probdata.Omega(2);

%% Costruzione dello spazio di prima approssimazione
deg=3;
dofs=40;
dim=dofs+2; % dimensione dello spazio di approssimazione
Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1); % nodi uniformi
space=Bspline_space(deg,Xi); % spazio di approssimazione
% Costruzione dello spazio gerarchico a partire da quello appena costruito
hspace=HBspline_space(space);

%% Paramtri di risoluzione
solver_set=HBspline_solver_set;
solver_set.maxDoF=350; 
solver_set.maxIter=8;
solver_set.minPercImpr=10;
solver_set.minPercIterImpr=5;

solver_set.maxRes=1e-2;
solver_set.maxRelResLoc=5;

solver_set.Marker='Dor'; solver_set.theta=0.25;
solver_set.PreMark=false; solver_set.PreMarkPerc=10;

solver_set.FastLocRes=true;
solver_set.VerboseMode=true;

%% Risolutore ADATTIVO
[uh, hspace_sol, solver_out]=HBspline_adaptive_solver(probdata, hspace, solver_set);

uhfn=@(t) hspace_sol.HBspline_appr(uh,t);

% grafico
F_sol_base=figure;

subplot(2,1,1)
plot(t,uhfn(t))
% ylim([0,1])

subp_base=subplot(2,1,2);
hspace_sol.plot_base;
ylim([0,1])

% Errore 
AdaptErr=L2error(uhfn, probdata.uex, probdata.Omega);
fprintf('Procedura adattiva con %d DoF in %d iterazioni, errore L^2 %f\n', solver_out.NoDoF,solver_out.NoIter, AdaptErr);
