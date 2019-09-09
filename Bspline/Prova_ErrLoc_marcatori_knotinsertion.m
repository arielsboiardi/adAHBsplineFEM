%% Inizilizzazione
clear all; close all; clc
addpath('.\Bspline_FEM')
addpath('.\funspace_ops')
addpath('.\Bsplines')

%% Dati del problema

% Problema trasporto e diffusione
Omega=[0,1];
b=100;
m=1;
u0=0;
u1=1;
f=@(t) 0.*t;
uex=@(x) (exp((b/m)*x)-1)/(exp(b/m)-1);

% % Problema funzione di Runge
% Omega=[0,1];
% 
% m=1;
% b=1;
% alpha=1000000;
% 
% syms z;
% uex=1/(1+alpha*(z-1/2).^2)-1/(1+alpha/4);
% duex=diff(uex,z);
% dduex=diff(duex,z);
% uex=matlabFunction(uex);
% duex=matlabFunction(duex);
% dduex=matlabFunction(dduex);
% f=@(t) -m*dduex(t)+b*duex(t);
% 
% u0=0;
% u1=0;

% % Problema con soluzione oscillante
% Omega=[0,pi];
% 
% m=1;
% b=1;
% 
% alpha=101;
% k=15;
% syms z;
% uex=(cos(k*z)).^alpha;
% duex=diff(uex,z);
% dduex=diff(duex,z);
% uex=matlabFunction(uex);
% duex=matlabFunction(duex);
% dduex=matlabFunction(dduex);
% 
% f=@(t) -m*dduex(t)+b*duex(t);
% 
% u0=1;
% u1=-1;


% Costruzione del problema 
probdata=problem_data_set(Omega, b, m, u0, u1, f, uex);

%% Risoluzione 
deg=2;

dofs=5;

dim=dofs+2; % dimensione dello spazio di approssimazione 
Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1); % nodi uniformi
    
space=Bspline_space(deg,Xi); % spazio di approssimazione 
    
%% Soluzione
[u, uh, A]=Bspline_solver(probdata,space);

%% Calcolo errore e residuo
tt=linspace(probdata.Omega(1),probdata.Omega(2), 100*numel(space.knots));

e=@(t) abs(u(t)-probdata.uex(t));
etaR=LocalRes(uh, probdata, space);

% Grafici
figure
plot(tt,e(tt))
hold on

plot(space.knots(1:end-1)+0.5*diff(space.knots), etaR, 'marker','square','LineStyle','none')
set(gca,'Yscale','log')

%% Test marcatore
addpath('.\Markers');

% [marked, etaR]=ThresMark(etaR,1e-6);
% [marked, etaR]=PreMark(etaR,0);
% marked=MaxMark(etaR,0.6);
% marked=DorMark(etaR,0.99);

markersetting=marker_set('Dor',0.5,true,10,false,1e-2);
marked=Marker(etaR,markersetting);
marked.show(space)
title(string(space.dim));

%% Knot Insertion
addpath('.\KnotInsertion')
space=KnotInsertion(space,marked);

