classdef HBspline_space
    % HBspline_space contiene le informazioni per costruire uno spazio di
    % B-splines gerarchiche.
    
    properties
        deg         % grado delle Bspline
        dim         % dimensione dello spazio gerarchico
        hknots      % indici dei attivi nodi della griglia gerarchica
        hcells      % indici delle celle attive della griglia gerarchica
        nlev        % numero di livelli
        A           % indici delle funzioni attive per ogni livello
        D           % indici delle funzioni non attive per ogni livello
        sp_lev      % informazioni di ogni livello dello spazio gerarchico
    end
    
    methods
        
        function hspace=HBspline_space(space,deg,dim,hknots,hcells,A,D,nlev,sp_lev)
            % Costruttore della classe HBspline_space. Possiamo costruire
            % la classe fornendo tutti i dati, oppure basare il nuovo
            % spazio gerarchico su un Bspline_space iniziale.
            %
            %   hspace=HBspline_space(space)
            %
            % INPUTS:
            %
            %   space:  Bspline_space che costituirà il primo livello dello
            %           spazio gerrchico
            %
            %   hspace=HBspline_space(deg,dim,knots,A,D,nlev,sp_lev)
            %
            % INPUTS:
            %
            %   deg:    grado delle Bspline che costituiscono lo spazio
            %           gerarchico, essendo lo stesso a tutti i livelli
            %   dim:    dimensione dello spazio gerarchico, ovvero numero
            %           totale di funzioni di base attive a tutti i livelli
            %   knots:  nodi della grigli gerarchica come definita nella
            %           trattazione teorica
            %   A:      cell array contente per ogni livello gli indici
            %           delle funzioni di base attive come vettotore
            %           lgoico
            %   D:      cell array contente per ogni livello gli indici
            %           delle funzioni di base disattive come vettore
            %           logico
            %   nlev:   numero totale di livelli, ovvero profondità della
            %           gerarchia
            %   sp_lev: cell array che in ogni livello contiene le
            %           informazioni dello spazio corrispondente in forma
            %           di Bspline_space (vedi classe dedicata)
            %
            % OUTPUS:
            %
            %   hspace: informazioni sullo spazio gerarchico come
            %           HBspline_space
            %
            % NOTE:
            %
            %   1. La scelta di salvare le funzioni attive e disattive in
            %   vettore logico invece che non i loro indici presenta alcuni
            %   vantaggi:
            %       a. Operazion insiemistiche con soli operatori booleani
            %       senza uso di funzioni di libreria.
            %       b. Migliore interfacci con alcune function in cui
            %       l'indicizzazione logica è più naturale.
            %       c. MAggiore volecità nell'esecuzione di alcune
            %       operazioni.
            %       d. La struttura dati proposta in letteratura [e. g. E.
            %       M. Garau, R. Vazquez, Algorithms for the implementation
            %       of adaptive isogeometric mathods using hierarchical
            %       splines] prevede di salvre un elenco di indici per le
            %       funzioni attive e uno per le funzoni non attive.
            %       L'implementazione che propongo comporta un utilizzo di
            %       memoria molto più ridotto.
            %
            
            %% Costruzione dello spazio gerarchico a partire da uno spazio 
            if nargin==1
                % Nel caso venga dato in input un Bspline_space, il
                % costruttore crea un nuovo spazio gerarchico usando lo
                % spazio dato come primo livello.
                
                % Molte propreità coincidono con quelle di space
                hspace.deg=space.deg;
                hspace.dim=space.dim; 
                
                % Space forma il primo livello
                hspace.nlev=1; 
                hspace.sp_lev{1}=space; 
                
                % Tutti i nodi e tutte le celle sono attivi
                hspace.hknots{1}=true(size(space.knots));
                hspace.hcells{1}=true(1,numel(space.knots)-1);
                
                % Tutte le B-spline sono attive al primo livello
                hspace.A{1}=[true(1,space.dim)]; 
                hspace.D{1}=~hspace.A{1}; 
                
                return
            end
            
            %% Costruzione dello spazio gerarchico dal nulla
            hspace.deg=deg;
            hspace.dim=dim;
            hspace.hknots=hknots;
            hspace.hcells=hcells;
            hspace.A=A;
            hspace.D=D;
            hspace.nlev=nlev;
            hspace.sp_lev=sp_lev;
            
        end
        
    end
end
