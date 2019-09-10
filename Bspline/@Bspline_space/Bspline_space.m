classdef Bspline_space
    
    properties
        deg         % grado delle B-splines
        knots       % vettore di nodi 
        dim         % dimensione dello spazio
    end
    
    methods
        
        function space=Bspline_space(deg, knots)
            % Costruisce un oggetto Bspline_space con gli attributi
            % compatibili con i dati. Il vettore di nodi knots deve essere
            % non esteso.
            space.deg=deg;
            reshape(knots,1,numel(knots)); % metto in riga
            space.knots=[knots(1)*ones(1,deg),knots,knots(end)*ones(1,deg)]; % estendo il vettore di nodi
            % Dalla teoria sappiamo che la dimensione dello spazio di
            % B-splines è pari alla somma delle molteplicità dei nodi
            % interni non ripetuti M + deg + 1, pertanto, poiché la
            % partizione estesa contiene M+2+2p nodi,
            space.dim=numel(space.knots)-deg-1;
            
            
            % fucntion in essa contenute.
            addpath(genpath('.'))
        end 

    end
    
end
