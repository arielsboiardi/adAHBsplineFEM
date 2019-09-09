function uH1=H1norm(u, du, a , b)
% H1norm : calcola la norma H1 della funzione u nello spazio di Hilbert
% H1([a,b]).
%
%   uH1=H1norm(u,du,a,b)
%
% INPUT
%
%   u: function handle alla funzione di cui caloclo la norma
%   du: fucntion handle alla derivata di u
%   a,b: estremi delll'intervallo su cui calcolo la norma
%
% OUTPUT
%
%   uL2: scalare rappresenta la norma L2 della funzione
%

uH1=sqrt(L2norm(u,a,b)+L2norm(du,a,b));

end