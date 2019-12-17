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

knots=hspace.sp_lev{1}.knots;
x0=knots(1); xN=knots(end);
t=x0:0.001:xN;

% figure
hold on
for L=1:hspace.nlev
    P{L}=[];
    spaceL=hspace.sp_lev{L};
    rng(L,'combRecursive');
    clrL=rand(1,3);
    leg_info{L}=strcat("Level ", num2str(L));
    for jdx=find(hspace.A{L})
        P{L}=plot(t,spaceL.Bspline_eval(jdx,t),'Color',clrL);
    end
    if isempty(P{L})
        P{L}=plot(1,1,'LineStyle','none');
    end
end
hold off

P=cellfun(@(V) V(1), P);
legend(P,leg_info,'AutoUpdate','off', 'interpreter','latex');
end
