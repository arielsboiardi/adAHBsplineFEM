function uL2=L2norm(u, a , b)
% L2norm : calcola la norma L2 della funzione u nello spazio di Lebesgue
% L2([a,b]).
%
%   uL2=L2norm(u)
%
% INPUT
%
%   u: function handle alla funzione di cui caloclo la norma
%   a,b: estremi delll'intervallo su cui calcolo la norma
%
% OUTPUT
%
%   uL2: scalare rappresenta la norma L2 della funzione
%

usq = @(t) u(t).^2;
uL2 = sqrt(integral(usq, a, b));

end