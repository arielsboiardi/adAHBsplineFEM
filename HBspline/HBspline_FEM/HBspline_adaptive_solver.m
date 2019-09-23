function [uh, hspace_sol, solver_out]=HBspline_adaptive_solver(probdata, hspace, solver_setting)
% HBspline_adaptive_solver determina la soluzione approssimata del problema
% probdata in uno psazio di B-spline gerarchiche costruito adattivamente
% per migliorare l'approssimazione del problema dato.
%
%   [uh, hspace_sol, solver_out]=HBspline_adaptive_solver(probdata, hspace, solver_setting)
%
% INPUTS:
%
%   probdata:       problem_data_set con le informazioni del problema.
%   hspace:         HBspline_space con le informazioni dello spazio
%                   gerarchico in cui costruire la prima approsismazione.
%   solver_setting: HBspline_solver_set con i parametri del procedimento
%                   adattivo.
%
% OUTPUTS
%
%   uh:         coefficienti della soluzione approssimata rispetto allo
%               spazio di B-spline gerarchiche hspace_sol.
%   hspace_sol: HBspline_space con le informazioni dello spazio
%               gerarchico in cui � costruita l'approssimazione finale.
%   solver_out: HBspline_solver_out con le ifnromazioni di uscita del
%               risolutore.
%
% NOTE:
%
%   1.  Le informazioni di uscita del risolutore servono per capire in base
%       a quale criterio di arresto � terminata la procedura, fare
%       confronti con altri metodi a parit� del numero di gradi di libert�
%       e altre possibili analisi che l'utente possa voler compiere.
%   2.  Dare come output lo spazio in cui � stat costruita la
%       approssimazione  finale � necessario per ricostruire la soluzione e
%       valutarla (almeno nella presente implementazione) ma � anche utile
%       per eventualmente ripetere la procedura adattiva a partire dallo
%       spazio finale nel caso l'utente, ispeziondo i dati di uscita,
%       ritenga che questo possa essere utile per migliorare
%       l'approssimazione ottenuta.
%

NoIter=0;   % numero iterazioni
eta_prec=Inf; % CONTROLLA COME FARE MEGLIO
while hspace.dim-2 <= solver_setting.maxDoF
    NoIter=NoIter+1;
    if NoIter > solver_setting.maxIter
        NoIter=NoIter-1;
        if solver_setting.VerboseMode
            fprintf('Raggiunto numero massimo di iterazioni \n')
        end
        break
    end
    
    % Risoluzione
    [uh,Ah]=HBspline_solver(probdata, hspace);
    hspace_sol=hspace;  % salvo lo spazio in cui ho la soluzione
    
    % Calcolo del residuo
    L=hspace.nlev;
    if L==1
        % Al primo giro etaR � da creare
        etaR=hLocRes(uh,probdata, hspace);
    else
        % ... poi da aggiornare
        etaR=hLocRes(uh,probdata, hspace, etaR);
    end
    
    % Stima dell'errore globale
    eta=hGlobRes(etaR);     % residuo globale
    
    IterImpr=abs(eta-eta_prec);
    if IterImpr < solver_setting.minIterImpr
        if solver_setting.VerboseMode
            fprintf(['Il miglioramento ottenuto con l''ultima iterazione � di %f, \n'...
                'minore alla soglia fissata di %f \n'],...
                IterImpr, solver_setting.minIterImpr)
        end
        break
    end
    eta_prec=eta;
    
    eta_L=norm(etaR{L},2);  % residuo sull'ultimo livello
    
    % Criterio di stop sul residuo locale
    RelImpr=eta_L/eta;
    if RelImpr < solver_setting.minPercImpr/100
        if solver_setting.VerboseMode
            fprintf(['Il miglioramento stimato ottenibile con questa gerarchia di raffinamenti\n',...
                '� di %f, minore del %d%% della stima totale dell''errore.\n'],...
                RelImpr, solver_setting.minPercImpr)
        end
        break
    end
    
    % Marcatura
    markersetting=marker_set(solver_setting.Marker,solver_setting.theta,...
        solver_setting.PreMark,solver_setting.PreMarkPerc,...
        true,solver_setting.maxResLoc);
    marked_cells=Marker(etaR{L},markersetting);
    
    % Passo la marcatura sulle B-splines
    marked_Bsplines=HBspline_Marker(hspace, marked_cells);
    
    % Raffinamento
    hspace=hspace.refine(marked_Bsplines);
end
if solver_setting.VerboseMode && hspace.dim-2 > solver_setting.maxDoF 
    fprintf
    ('Raggiunto il numero massimo di iterazioni')
end

% Compilo l'uscita rel risolutore
solver_out=HBspline_solver_out;
solver_out.NoIter=NoIter;
solver_out.NoDoF=hspace_sol.dim-2;
solver_out.GlobalRes=eta;
solver_out.LocalRes=etaR{L};
solver_out.LastIterImpr=IterImpr;
solver_out.Amatrix=Ah;

end
