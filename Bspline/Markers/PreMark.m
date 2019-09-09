function [marked,etaR_rest]=PreMark(etaR,eps)
% MaxMark premarca all'eps% rispetto al residuo locale
%
%   marked=MaxMark(etaR,theta,space)
%
% INPUTS:
%
%   etaR:   vettore con i residui locali 
%   eps:    percentuale degli elementi da premarcare
% 
% OUTPUTS:   
%
%   marked: informazioni nella marcatura (classe marker_out)
%   etaR_rest: vettore dei residui azzerato sugli elementi
%       premarcati, in modo che non vengano marcati successivamente 
%

N=numel(etaR);
etaR_rest=etaR;
numel_marked=fix(N*eps*0.01); % NoMarked è eps% intero degli elementi

if nnz(etaR)>numel_marked
    % Senza questo accorgimento si rischia di marcare elementi che non
    % hanno errore. In effetti se il numero di elementi con errore è minore
    % del numero di elementi da marcare non ha senso procedere.
    [~,ind]=sort(etaR,'descend');
    ind=ind(1:numel_marked);
    % Prendo gli indici in numero numel_marked corrispondenti agli elementi
    % di etaR massimi.
    etaR_rest(ind)=0;
    % Azzero il residuo in corrispondenza dei residui marcati
    ind=ismember(1:N, ind);
    % Trasformo gli indici in un vettore logico come previsto da lla calsse
    % classe marker_out.
else
    % Ovviamente nel caso non venga effettuata la marcatura nessun elemento
    % è marcato.
    ind=false(1,N);
    numel_marked=0;
end

marked=marker_out(ind,numel_marked);

end