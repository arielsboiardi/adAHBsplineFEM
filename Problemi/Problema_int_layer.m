% Problema soluzione tipo Runge
Omega=[0,1];

m=1;
b=1;
alpha=100000;

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
