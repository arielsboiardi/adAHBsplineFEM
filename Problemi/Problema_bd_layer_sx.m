% Problema trsposrto-diffusione al contrario
Omega=[0,1];
b=-500;
m=1;
u0=1;
u1=0;
f=@(t) 0.*t;
uex=@(x) (exp((-b/m)*(1-x))-1)/(exp(-b/m)-1);
