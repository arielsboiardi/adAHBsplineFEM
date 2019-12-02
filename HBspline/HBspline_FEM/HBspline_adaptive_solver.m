function [uh, hspace_sol, solver_out]=HBspline_adaptive_solver(probdata, hspace, solver_setting)
% HBspline_adaptive_solver determina la soluzione approssimata del problema
% probdata in uno spazio di B-spline gerarchiche costruito adattivamente
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
%               gerarchico in cui è costruita l'approssimazione finale.
%   solver_out: HBspline_solver_out con le ifnromazioni di uscita del
%               risolutore.
%
% NOTE:
%
%   1.  Le informazioni di uscita del risolutore servono per capire in base
%       a quale criterio di arresto è terminata la procedura, fare
%       confronti con altri metodi a parità del numero di gradi di libertà
%       e altre possibili analisi che l'utente possa voler compiere.
%   2.  Dare come output lo spazio in cui è stat costruita la
%       approssimazione  finale è necessario per ricostruire la soluzione e
%       valutarla (almeno nella presente implementazione) ma è anche utile
%       per eventualmente ripetere la procedura adattiva a partire dallo
%       spazio finale nel caso l'utente, ispeziondo i dati di uscita,
%       ritenga che questo possa essere utile per migliorare
%       l'approssimazione ottenuta.
%

time=cputime;

NoIter=0;   % numero iterazioni
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
    
    if solver_setting.FastLocRes
        if L==1
            etaR=hLocResFast(uh,probdata, hspace);
        else
            etaR=hLocResFast(uh,probdata, hspace, etaR);
        end
    else
        etaR=hLocRes(uh, probdata, hspace);
    end
    % Stima dell'errore globale
    eta=hGlobRes(etaR);     % residuo globale
    
    if NoIter>1
        % Il miglioramento di iterazione ha senso solo dalla seconda
        % iterazione in poi
        IterRelImprPerc=(abs(eta-eta_prec)/eta_prec)*100;
        if IterRelImprPerc < solver_setting.minPercIterImpr
            if solver_setting.VerboseMode
                fprintf(['Il miglioramento ottenuto con l''ultima iterazione è di %f, \n'...
                    'minore al %d%% della stima totale dell''errore %f.\n'],...
                    IterRelImprPerc/100, solver_setting.minPercIterImpr, eta)
            end
            break
        end
    end
    eta_prec=eta; % Save global error estimate at current iteration
    
    eta_L=norm(etaR{L},2);  % residuo sull'ultimo livello
    
    % Criterio di stop sul residuo locale
    RelImprPerc=(eta_L/eta)*100;
    if RelImprPerc < solver_setting.minPercImpr
        if solver_setting.VerboseMode
            fprintf(['Il miglioramento stimato ottenibile con questa gerarchia di raffinamenti\n',...
                'è di %f, minore del %d%% della stima totale dell''errore %f.\n'],...
                RelImprPerc/100, solver_setting.minPercImpr,eta)
        end
        break
    end
    
    % Marcatura
    markersetting=marker_set(solver_setting.Marker,solver_setting.theta,...
        solver_setting.PreMark,solver_setting.PreMarkPerc,...
        true,solver_setting.maxRelResLoc);
    marked_cells=Marker(etaR{L},markersetting);
    
    % Passo la marcatura sulle B-splines
    marked_Bsplines=HBspline_Marker(hspace, marked_cells);
    
    % Raffinamento
    hspace=hspace.refine(marked_Bsplines);
end
if solver_setting.VerboseMode 
    if hspace.dim-2 > solver_setting.maxDoF
        fprintf('Maximum number of DoF reached. \n')
    end
    fprintf('Adaptive procedure required %f seconds. \n',cputime-time)
end


% Compilo l'uscita rel risolutore
solver_out=HBspline_solver_out;
solver_out.NoIter=NoIter;
solver_out.NoDoF=hspace_sol.dim-2;
solver_out.GlobalRes=eta;
solver_out.LocalRes=etaR;
solver_out.LastIterImpr=IterRelImprPerc/100;
solver_out.Amatrix=Ah;

end
