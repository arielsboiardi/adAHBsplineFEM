%% Inizilizzazione
clear all; close all; clc
addpath('.\Bspline_FEM')
addpath('.\funspace_ops')
addpath('.\Bsplines')

%% Dati del problema

% Problema trasporto e diffusione
Omega=[0,1];
b=10;
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
% alpha=10000;
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
% alpha=1;
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

%% Risoluzioni
DoF=[2000];
deg=2;

kdx=1;
for dofs=DoF
    dim=dofs+2; % dimensione dello spazio di approssimazione 
    Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1); % nodi uniformi
    
    space=Bspline_space(deg,Xi); % spazio di approssimazione 
    
    % Soluzione
    [u]=Bspline_solver(probdata,space);
    
    % Valutazione dell'errore
    ErrL2(kdx)=L2error(u,uex,probdata.Omega);
    
    kdx=kdx+1;
end

%% Grafici
t=probdata.Omega(1):0.0001:probdata.Omega(2);

% Errore puntuale
figure
plot(t,abs(u(t)-uex(t)))
set(gca,'Yscale','log')
title("Errore puntuale")

% Errore in norma
figure
plot(DoF,ErrL2,'marker','square','MarkerEdgeColor','b','color','b')
set(gca,'Yscale','log','Xscale','log')
title("Errore L^2")

% Soluzione
figure
plot(t,u(t))
title("Soluzione")
