function marked=MaxMark(etaR,theta)
% MaxMark esegue la marcatura con l'algoritmo del massimo con parametro
% theta.
%
%   marked=MaxMark(etaR,theta,space)
%
% Restituisce  il risultato della marcatura del massimo sul vettore di
% residui locali etaR
%
% INPUTS:
%
%   etaR:   vettore con i residui locali 
%   theta:  soglia 0<theta<1
% 
% OUTPUTS:   
%
%   marked: informazioni nella marcatura (classe marker_out)
%

eta=max(etaR); 
% Tutte le operazioni sono vettorizzate in
ind=(etaR>=theta*eta);
numel=nnz(ind);
marked=marker_out(ind,numel);

end