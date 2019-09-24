% Problema trasporto e diffusione
Omega=[0,1];
b=100;
m=1;
u0=0;
u1=1;
f=@(t) 0.*t;
uex=@(x) (exp((b/m)*x)-1)/(exp(b/m)-1);
