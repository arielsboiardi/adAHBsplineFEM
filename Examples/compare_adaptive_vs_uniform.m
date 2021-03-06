%% COMPARISON BETWEEN ADAPITVE PROCEDURE AND UNIFORM REFINEMENT
% In this fi�le a complete example of use of the adaptive solver is given,
% with details about the setting used and hot to produce similar examples.
% Files with examples discussed in the report are in the Problems
% directory.

clear all; close all; clc
addpath(genpath('./..'))

%% Loa problem data
% Problema_bd_layer_dx;
% Problema_bd_layer_sx;
Problema_int_layer;
% Problema_sol_Heaviside_regolarizzata;

% We now build a probdata variable containing an instance of data of the
% problem of the class problem_data_set
probdata=problem_data_set(Omega, b, m, u0, u1, f, uex);
t=probdata.Omega(1):0.001:probdata.Omega(2);

%% Build initial approximation space
deg=5;      % chose degree of the B-splines
dofs=17;    % Chose initial number of DoF

dim=dofs+2; % Dimension is computed consequently
Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1);  % uniformly spaced knots
space=Bspline_space(deg,Xi);    % uniform soace with choosen deg and DoF
hspace=HBspline_space(space);   % becomes first level af a hierarchical space

%% Parameters of the adaptive solver
% Parameters for the solver are stored in an istance of the class 
% HBspline_solver_set
solver_set=HBspline_solver_set;

% First group is the stopping criteria: the first are technical: we need
% them to prevent the algoritm from loppijng infinitely if no other
% stopping cterion is satisfied ina reasonable time. 
% The consd group contains conditions aimed to stop the procedure in a good
% point to get the best approximation with the least amount of iterations.
% These are explained in more detail in the techincal report. 

solver_set.maxDoF=350;          % Number of degrees of freedom that arrests the procedure
solver_set.maxIter=8;           % Maximum number of iteration of the procedure
solver_set.minPercImpr=10;      
solver_set.minPercIterImpr=5;

% The following are the settings of the marker: more details os this in the
% report.
solver_set.maxRes=1e-2;
solver_set.maxRelResLoc=5;
solver_set.Marker='Dor'; solver_set.theta=0.15;
solver_set.PreMark=false; solver_set.PreMarkPerc=2;

solver_set.FastLocRes=true;
solver_set.VerboseMode=true;

%% Adaptive solver execution
[uh, hspace_sol, solver_out]=HBspline_adaptive_solver(probdata, hspace, solver_set);
uhfn=@(t) hspace_sol.HBspline_appr(uh,t);

% Plots obtaines solution and basis of the approximation space
F_sol_base=figure;

subplot(2,1,1)
plot(t,uhfn(t))
% ylim([0,1])

subp_base=subplot(2,1,2);
hspace_sol.plot_base;
ylim([0,1])

% COmputes error
AdaptErr=L2error(uhfn, probdata.uex, probdata.Omega);
fprintf('Procedura adattiva con %d DoF in %d iterazioni, errore L^2 %f\n', solver_out.NoDoF,solver_out.NoIter, AdaptErr);

%% Uniform solver, to compare error
dofs=solver_out.NoDoF; % Same DoFs of the adaptive solver
% dofs=100; %%% Try to get the same error and compare CPUtimes

% Builds approximation space on uniform knot vector
dim=dofs+2; 
Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1); % nodi uniformi
space=Bspline_space(deg,Xi); % spazio di approssimazione

time=cputime;

[~,uh]=Bspline_solver(probdata,space);
uhfn=@(t) space.Bspline_appr(uh,t);

fprintf('Non-adaptive procedure required %f seconds.\n',cputime-time)

% Computes error
NonAdaptErr=L2error(uhfn,probdata.uex,probdata.Omega);
fprintf('Procedura non adattiva con %d DoF, errore L^2 %f\n', dofs, NonAdaptErr);
