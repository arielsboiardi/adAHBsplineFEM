% Problema con soluzione logistica ~ Heaviside
Omega=[-1,1];

m=1;
b=1;

k=90; % Paramtro cche determina la ripidità della soluzione in 0

% Costruisco la soluzione e le sue derivate simboliche
syms z;
uex=1./(1+exp(-2*k*z));
duex=diff(uex, z);
dduex=diff(duex, z);

% Trasfirmo in handle valutabili
uex=matlabFunction(uex);
duex=matlabFunction(duex);
dduex=matlabFunction(dduex);

% Il termine noto è per costruzione del problema
f=@(t) -m*dduex(t)+b*duex(t);

u0=uex(Omega(1));
u1=uex(Omega(2));
