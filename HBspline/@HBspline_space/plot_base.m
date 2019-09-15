function plot_base(hspace, varargin)
% plot_base traccia in una nuova figura il grafico delle funzioni della
% base gerarchica dello spazio hspace.
%
%   plot_base(hspace, varargin)
%
% INPUTS:
%
%   hspace:     spazio di cui tracciare la base
%   varargin:   argomenti opzionali della funzione plot per risultati 
%               grafici particolari
%
% OUTPUT:
%
%   figura con i grafici delle funzioni della base gerarchica
%
% NOTE:
%   1. I colori dei livelli sono generati casualemnte per creare in modo
%   semplice un numero arbitario di combinazioni crmatiche in scala RGB.
%   L'impostazione del seed della funzione random per ogni livello consente
%   però di ottenere lo stesso risultato per ogni esecuzione. Pe il
%   generatore ho scelto Combined Multiple Recursive perché genera una
%   successione a mio parere più piacevole enaturale. 

t=hspace.knots(1):0.001:hspace.knots(end);


% figure
hold on
P{1}=[];
for L=1:hspace.nlev
    spaceL=hspace.sp_lev{L};
    rng(L,'combRecursive');
    clrL=rand(1,3);
    leg_info{L}=strcat("Livello", num2str(L));
    for jdx=find(hspace.A{L})
        P{L}=plot(t,spaceL.Bspline_eval(jdx,t),'Color',clrL);
    end
    if isempty(P{L})
        P{L}=plot(1,1,'LineStyle','none');
    end
end

P=cellfun(@(V) V(1), P);
legend(P,leg_info);
end
