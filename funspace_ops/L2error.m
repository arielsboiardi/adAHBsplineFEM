function errL2=L2error(u,v,Omega)
% L2error : calcola lo scarto fra u e v in norma di Lebesgue
% sull'intervallo [a,b]
%
% INPUT
%
%   u,v: handles alle funzione di cui calcolo lo scarto
%   Omega: dominio 
%
% OUTPUT 
%
%   errL2: scalto in norma L2 fra u e v su Omega
%

sc=@(t) u(t)-v(t);
errL2=L2norm(sc, Omega(1), Omega(2));

end
