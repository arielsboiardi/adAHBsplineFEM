classdef HBspline_solver_set
    % HBspline_solver_set contiene i parametri del risolutore adattivo
    % HBspline_adaptive_solver.
    
    properties
        maxDoF          % Numero di gradi di libertà a cui arrestare la procedura.
        maxIter         % Numero di iterazioni a cui arrestare la procedura.
        minPercImpr     % Minimo valore del miglioramento possibile rispetto alla stima globale dell'errore per cui ha senso iterare il procediento.
        minPercIterImpr % Minimo valore del miglioramento in una iterazione per cui si stima abbia senso prosegure.
        
        maxRes          % Massimo valore accettabile per lo stimatore residuale dell'errore globale.
        maxResLoc       % Massimo valore accettabile per lo stimatore residuale dell'errore locale.
        
        Marker          % Selezione del marcatore.
        theta           % Valore del parametro theta del marcatore selezionato.
        PreMark         % Attivazione del premarker.
        PreMarkPerc     % Percetuale di premarking
       
        VerboseMode     % Attivazione della modalità verbosa che commenta i risultati intermedi nella finestra dei comandi. 
    end
    
end
