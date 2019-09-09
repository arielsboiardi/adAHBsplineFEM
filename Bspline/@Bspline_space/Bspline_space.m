classdef Bspline_space
    
    properties
        deg         % grado delle B-splines
        knots       % vettore di nodi 
        dim         % dimensione dello spazio
    end
    
    methods
        %% Costrutture della classe
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

        %% Valutazioni
        function B=Bspline_eval(space, idx, t)
            % Valuta in t la idx-esima B-spline del Bspline_space space. 
            %
            % La valutazione avviene mediante la ricorsione di Cox-De Boor
            % contenuta nella libreria Bsplines salvata a parte per
            % eventuale accesso indipendente dalla classe.
            
            B=bspline(idx,space.deg,space.knots,t);

        end
        
        function dB=dBspline_eval(space, idx, t)
            % Valuta in t la derivata della idx-esima B-spline del 
            % Bspline_space space. 

            dB=dbspline(idx,space.deg,space.knots,t);
            
        end
        
        function ddB=ddBspline_eval(space, idx, t)
            % Valuta in t la derivata seconda della idx-esima B-spline del 
            % Bspline_space space. 
            
            ddB=ddbspline(idx,space.deg,space.knots,t);
            
        end
        
        %% Valutazione di un approssimante nello spazio 
        
        function u=Bspline_appr(space,coefs,t)
            % Valuta la spline con coefficienti coefs rispetto alla base
            % del Bspline_spase space in t. 
            
            if numel(coefs)~=space.dim
                error('Controlla il numero di coefficienti')
            end
            
            u=0; % assegno 
            
            for idx=1:space.dim
                u=u+coefs(idx)*space.Bspline_eval(idx,t);
            end
        end
        
        function du=dBspline_appr(space,coefs,t)
            % Valuta la derivata della funzione con coefficeinti coefs
            % rispetto alla base di space
            
            if numel(coefs)~=space.dim
                error('Controlla il numero di coefficienti')
            end
            
            du=0; % assegno
            
            for idx=1:space.dim
                du=du+coefs(idx)*space.dBspline_eval(idx,t);
            end
        end
        
        function ddu=ddBspline_appr(space,coefs,t)
            % Valuta la derivata 2 della funzione con coefficeinti coefs
            % rispetto alla base di space
            
            if numel(coefs)~=space.dim
                error('Controlla il numero di coefficienti')
            end
            
            ddu=0; % assegno 
            
            for idx=1:space.dim
                ddu=ddu+coefs(idx)*space.ddBspline_eval(idx,t);
            end
        end
        
        %% Rappresentazione della base dello spazio
        
        function plot_base(space)
            % Rappresenta la base dello spazio space, varargin contiene le
            % impostazioni grafiche come plot di libreria.
            
            t=linspace(space.knots(1),space.knots(end),100*numel(space.knots));
            figure
            hold on
            for kdx=1:space.dim
                plot(t,space.Bspline_eval(kdx,t))
            end
        end
            
    end
    
end
