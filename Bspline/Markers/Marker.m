function marked=Marker(etaR,setting)
% Marker esegue la procedura generale di marcatura secondo le impostazioni
% setting della classe marker_set.
%
%   marked=Marker(etaR,set)
%
% INPUTS:
%
%   etaR: vettore dei residui
%   set: informazioni per il marcatore (classe marker_set)
%
% OUTPUT:
%
%   marked: informazioni elementi marcati (classe marker_out)
%

% Inizializzo il vettore di uscita, a priori nulla viene marcato.
marked=marker_out(zeros(size(etaR)),0);

if setting.thres_mark
    % Se le impostazioni del marcatore lo prevede effettuo la marcatura a
    % soglia e aggiungo gli elementi marcati alla variabile marked.
    [marked1, etaR]=ThresMark(etaR,setting.thres);
    marked.ind=logical(marked.ind+marked1.ind);
    marked.numel=marked.numel+marked1.numel;
end

if setting.premark
    % Se le impostazioni del marcatore lo prevede effettuo il premarking e
    % aggiungo gli elementi marcati alla variabile marked.
    [marked1, etaR]=PreMark(etaR,setting.eps);
    marked.ind=logical(marked.ind+marked1.ind);
    marked.numel=marked.numel+marked1.numel;
end

switch setting.type
    % In base alle impostazioni uso uno dei due marcatori.
    case 'Dor'
        marked1=DorMark(etaR, setting.theta);
    case 'Max'
        marked1=MaxMark(etaR,setting.theta);
end
% Aggiungo il risultato del marcatore agli elementi marcati fino ad ora.
marked.ind=logical(marked.ind+marked1.ind);
marked.numel=marked.numel+marked1.numel;
end
