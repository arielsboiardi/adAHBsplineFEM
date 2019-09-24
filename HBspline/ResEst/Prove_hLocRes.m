clear all; close all; clc

%% Dati del problema
% Problema_bd_layer_dx;
% Problema_bd_layer_sx;
% Problema_int_layer;
% Problema_sol_oscillante;
Problema_sol_Heaviside_regolarizzata;

% Costruzione del problema
probdata=problem_data_set(Omega, b, m, u0, u1, f, uex);
t=probdata.Omega(1):0.001:probdata.Omega(2);

%% Costruzione dello spazio di prima approssimazione
deg=2;

dofs=20;

dim=dofs+2; % dimensione dello spazio di approssimazione
Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1); % nodi uniformi

space=Bspline_space(deg,Xi); % spazio di approssimazione

% Costruzione dello spazio gerarchico a partire da quello appena costruito
hspace=HBspline_space(space);

%% Approssimazione in hspace
Ah=HBspline_Assembly_opt(hspace,probdata);
Fh=HBspline_load_opt(hspace,probdata);
uh=Ah\Fh;

uh=[probdata.u0; uh; probdata.uL];

uhfn=@(t) hspace.HBspline_appr(uh,t);

% grafico
F_sol_base=figure;

subplot(2,1,1)
plot(t,uhfn(t))
% ylim([0,1])

subp_base=subplot(2,1,2);
hspace.plot_base;
ylim([0,1])

%% Stima residuale

% === Calcolo il residuo localmente all'ultimo livello e lo aggiungo ai
% residui già calcolati
L=hspace.nlev;
if L==1
    etaR=hLocRes(uh,probdata, hspace);
else
    etaR=hLocRes(uh,probdata, hspace, etaR);
end


% === Calcolo il residuo globale della nuova soluzione
eta=0;
for ldx=1:L
    eta=eta+sum(etaR{ldx}.^2);
end
eta=sqrt(eta);  % err globale

etaR_L=etaR{L}; % residuo all'ultimo livello
space_L=hspace.sp_lev{L}; % spazio dell'ultimo livello
eta_L=norm(etaR_L,2); % residuo  sull'ultimo livello

%% Errore L2

for jdx=1:numel(hspace.hcells{L})
    if hspace.hcells{L}(jdx)
        ErrL2{L}(jdx)=L2error(@(t) hspace.HBspline_appr(uh,t), probdata.uex, [space_L.knots(jdx),space_L.knots(jdx+1)] );
    else
        ErrL2{L}(jdx)=0;
    end
end

% F_errL2_vs_etaR=figure;
% plot(1:numel(etaR{L}), etaR{L},'diamond',1:numel(etaR{L}), ErrL2{L}, 'diamond')
% set(gca,'Yscale','log')

%% Marcatura all'ultimo livello

% Marcatura sulle celle
markersetting=marker_set('Dor',0.5,true,3,true,1);
marked_cells=Marker(etaR_L,markersetting);
figure(F_sol_base)
marked_cells.show(space_L)

% Passo amrcatura sule B-spline
marked_Bsplines=HBspline_Marker(hspace, marked_cells);

%% Aggiunta livello
hspace=hspace.refine(marked_Bsplines);
