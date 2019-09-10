clear all; close all; clc;
addpath(genpath('..'));
%% Dati del problema

% % Problema trasporto e diffusione
% Omega=[0,1];
% b=10;
% m=1;
% u0=0;
% u1=1;
% f=@(t) 0.*t;
% uex=@(x) (exp((b/m)*x)-1)/(exp(b/m)-1);

% Problema funzione di Runge
Omega=[0,1];

m=1;
b=1;
alpha=10000;

syms z;
uex=1/(1+alpha*(z-1/2).^2)-1/(1+alpha/4);
duex=diff(uex,z);
dduex=diff(duex,z);
uex=matlabFunction(uex);
duex=matlabFunction(duex);
dduex=matlabFunction(dduex);
f=@(t) -m*dduex(t)+b*duex(t);

u0=0;
u1=0;

% % Problema con soluzione oscillante
% Omega=[0,1];
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
deg=2;

dofs=15;

dim=dofs+2; % dimensione dello spazio di approssimazione 
Xi=linspace(probdata.Omega(1), probdata.Omega(2), dim-deg+1); % nodi uniformi
    
space=Bspline_space(deg,Xi); % spazio di approssimazione 

% Costruzione dello spazio gerarchico a partire da quello appena costruito
hspace=HBspline_space(space);

%% Assemblaggio e carico in spazio gerarchico ad un livello 
% Ah=HBspline_Assembly(hspace,probdata);
% Fh=HBspline_load(hspace,probdata);

% Confronto con la soluzione notoriamente giusta
A=Bspline_Assembly(space, probdata);
F=Bspline_load(space, probdata);
u=A\F;
u=[probdata.u0; u; probdata.uL];

%grafico
figure
t=0:0.01:1;
plot(t,space.Bspline_appr(u,t))
% title('Controllo non gerarchico')
ylim([-0.1,1])

indice=1;
print('-dpng','-r190',strcat(num2str(indice),'.png'))
indice=indice+1;

%% Aggiunta livello 
hspace=hspace.refine(61:71);
Ah=HBspline_Assembly(hspace,probdata);
Fh=HBspline_load(hspace,probdata);
uh=Ah\Fh;
uh=[probdata.u0; uh; probdata.uL];
% grafico 
figure
plot(t,hspace.HBspline_appr(uh,t))
ylim([-0.1,1])

%Salva
print('-dpng','-r190',strcat(num2str(indice),'.png'))
indice=indice+1;