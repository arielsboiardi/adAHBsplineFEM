clear all; close all; clc

%% Load problem
Problema_bd_layer_dx;
% Problema_bd_layer_sx;
% Problema_int_layer;
% Problema_sol_oscillante;
% Problema_sol_Heaviside_regolarizzata;


probdata=problem_data_set(Omega, b, m, u0, u1, f, uex);
t=probdata.Omega(1):0.001:probdata.Omega(2);

%% Uniform approximation space
deg=3;
dofs=10\0;
dim=dofs+2; % dimensione dello spazio di approssimazione
Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1); % nodi uniformi
space=Bspline_space(deg,Xi); % spazio di approssimazione
% Costruzione dello spazio gerarchico a partire da quello appena costruito
hspace=HBspline_space(space);

%% Solution 
[~,uh]=Bspline_solver(probdata,space);
uhfn=@(t) space.Bspline_appr(uh,t);
plot(t,uhfn(t))
