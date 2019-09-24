classdef HBspline_solver_out
    % HBspline_solver_out contiene le informazioni di uscita del risolutore
    % adattivo in spazi di B-splines gerarchiche. 
    %   Una volta ottenuta la soluzione prodotta dal risolutore adattivo,
    %   l'utente potrebbe voler esaminare ache alcuni risultati intermedi
    %   ed essere in grado di valutare la qualità della soluzione. Un
    %   oggetto di questa classe, prodotto come output ad ogni esecuzione
    %   di HBspline_adaptive_solver contiene le informazioni che riteniamo
    %   utili a questo scopo. 
    
    properties
        NoIter          % Numero di iterazioni in cui è stata raggiunta la soluzione.
        NoDoF           % Numero di gradi di libertà della soluzione raggiunta.
        GlobalRes       % Stima residuale dell'errore globale.
        LocalRes        % Stima residuale su ogni cella attiva della griglia gerarchica.
        LastIterImpr    % Miglioramnto ottenuto con l'ultima iterazione della procedutra adattiva.
        MaxPossibImpr   % Massimo miglioramento ottenibile nello spazio gerarchico in cui è calcolata la soluzione finale. 
        Amatrix         % Matrice di rigidezza della soluzione finale.
    end
end
