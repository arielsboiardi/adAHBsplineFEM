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
solver_set.maxDoF=1000;
solver_set.maxIter=7;
solver_set.minPercImpr=0;
solver_set.minPercIterImpr=0;

solver_set.maxRes=1e-2;
solver_set.maxRelResLoc=1;

solver_set.Marker='Dor'; solver_set.theta=0.5;
solver_set.PreMark=true; solver_set.PreMarkPerc=3;

solver_set.FastLocRes=true;
solver_set.VerboseMode=true;

%% Covnergence plot
max_iter=solver_set.maxIter;
for repeat=1:max_iter
    %% Risolutore ADATTIVO
    [uh,Ah]=HBspline_solver(probdata, hspace);
    uhfn=@(t) hspace.HBspline_appr(uh,t);
    dim=hspace.dim;
    L=hspace.nlev;
    
    % Residuo
    if repeat==1
        etaR=hLocResFast(uh,probdata, hspace);
    else
        etaR=hLocResFast(uh,probdata, hspace, etaR);
    end
    eta=hGlobRes(etaR);     % residuo globale
    
    % Marcatura
    markersetting=marker_set(solver_set.Marker,solver_set.theta,...
        solver_set.PreMark,solver_set.PreMarkPerc,...
        true,solver_set.maxRelResLoc);
    marked_cells=Marker(etaR{L},markersetting);
   
    % Passo la marcatura sulle B-splines
    marked_Bsplines=HBspline_Marker(hspace, marked_cells);
    
    % Raffinamento
    hspace=hspace.refine(marked_Bsplines);
    
    % Errore
    AdaptErr(repeat)=L2error(uhfn, probdata.uex, probdata.Omega);
    
    %% Risolutore UNIFORME con stesi DoF
    Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1); % nodi uniformi
    space=Bspline_space(deg,Xi); % spazio di approssimazione
    [~,uh_unif]=Bspline_solver(probdata,space);
    uhfn_unif=@(t) space.Bspline_appr(uh_unif,t);
    UnifErr(repeat)=L2error(uhfn_unif,probdata.uex,probdata.Omega);
    
    DOFS(repeat)=dim-2;
end


plot(DOFS, AdaptErr, 'k-o')
hold on 
plot(DOFS, UnifErr, 'k-diamond')
set(gca,'YScale','log')
ylabel('$L^2$-norm error','interpreter','latex','FontSize',11)
xlabel('degrees of freedom', 'interpreter','latex','FontSize',11)
legend('Adaptive','Uniform','interpreter','latex','FontSize',11,'Location','SouthWest')
