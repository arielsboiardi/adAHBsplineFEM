function  [marked, etaR_rest]=ThresMark(etaR, threshold)
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

etaR_rest=etaR;
indcs=etaR>threshold;
marked=marker_out(indcs,nnz(indcs)); 
etaR_rest(indcs)=0;

end