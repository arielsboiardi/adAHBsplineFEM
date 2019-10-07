function  [marked, etaR_rest]=ThresMark(etaR, gamma)
% ThresMark marca tutti gli elementi che hanno residuo locale maggiore 
% della soglia threshold.
%
%   [marked, etaR_rest]=ThresMark(etaR, threshold)
%
% INPUTS:
%
%   etaR: vettore di residui locali
%   threshold: soglia per la marcatura
%
% OUTPUT:
%
%   marked: informazioni sugli elemnti marcati (marker_out)
%   etaR_rest: vettore dei residui con gli elementi marcati
%       azzerati
%

eta=norm(etaR,2); % Global error estimate
etaR_rest=etaR;
indcs=etaR/eta>gamma;
marked=marker_out(indcs,nnz(indcs)); 
etaR_rest(indcs)=0;

end
