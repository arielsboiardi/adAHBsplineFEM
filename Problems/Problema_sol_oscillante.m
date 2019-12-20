% Problema con soluzione periodica oscillante

Omega=[0,pi];

m=1;
b=1;

alpha=101;
k=5;
syms z;
uex=(cos(k*z)).^alpha;
duex=diff(uex,z);
dduex=diff(duex,z);
uex=matlabFunction(uex);
duex=matlabFunction(duex);
dduex=matlabFunction(dduex);

f=@(t) -m*dduex(t)+b*duex(t);

u0=1;
u1=(-1)^alpha;
