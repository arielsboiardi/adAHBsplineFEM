%% clear all; close all; clc;
addpath(genpath('..'));
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

%% Costruzione dello spazio di prima approssimazione 
deg=3;
dofs=5;

dim=dofs+2; % dimensione dello spazio di approssimazione 
Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1); % nodi uniformi
    
space=Bspline_space(deg,Xi); % spazio di approssimazione 

% Costruzione dello spazio gerarchico a partire da quello appena costruito
hspace=HBspline_space(space);

%% Confronto matrici di rigidezza non gerarchiche con le due fucntions
A=Bspline_Assembly(space, probdata);
AH=HBspline_Assembly(hspace, probdata);
A-AH