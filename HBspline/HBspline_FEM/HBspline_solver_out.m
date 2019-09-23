classdef HBspline_solver_out
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
