function marked=DorMark(etaR, theta)
% DorMark esegue la marcatura con l'algoritmo di Dörfler con riduzaione del
% residuo locale garantita. 
%
%   marked=DorMark(etaR, theta)
%
% INPUTS:
%
%   etaR: vettore dei residui locali
%   theta: parametro del marcatore
%
% OUTPUTS:
%
%   marked: informazioni sulla marcatura (marker_out class)
%

N=numel(etaR);
idMarked=[];
NoMarked=0;
Sigma=0; % Rappresenta (errore dovuto agli elementi selezionati)^2
err_glob=sum(etaR.^2); % Rappresenta (errore globale)^2

while Sigma<theta*err_glob
    Tt=setdiff([1:N],idMarked);
    eta=max(etaR(Tt));
    for K=Tt
        if etaR(K)==eta
            idMarked=[idMarked,K];
            NoMarked=NoMarked+1;
            Sigma=Sigma+etaR(K)^2;
        end
    end
end

ind=ismember(1:N,idMarked);
marked=marker_out(ind,NoMarked);

end
