function eta=hGlobRes(etaR)
% hGlobRes calola la stima globale dell'errore mediate stimatore residuale
% calcolato sui diversi livelli di uno spazio gerarchico (come in hLocRes).
%
%   eta=hGlobRes(etaR)
%
% INPUTS:
%
%   etaR:   cell array di L livelli L uguale al numero di livelli dello
%           spazio gerarhcico sottostante. In genere etaR è prodotto
%           iterativamente da hLocRes.m
%
% OUTPUTS:
%
%   eta:    stima globale dell'errore, come previsto dalla teoria, data
%           dalla norma 2 di tutti i residui locali sui vari livelli. 
%

L=numel(etaR);
eta=0;
for ldx=1:L
    eta=eta+sum(etaR{ldx}.^2);
end
eta=sqrt(eta);

end
