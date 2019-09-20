function supp_funs=get_supported_functions(space, fun_ind)
% get_supported_functions calcola le funzioni della base di space che hanno
% supporto comune con le funzioni indicizzate in fun_ind.
%
%   supp_funs=get_supported_functions(space,fun_ind)
%
% INPUTS: 
%
%   space:      Bspline_space in cui si cercano le funzioni
%   fun_ind:    indici delle funzioni per cui vogliamo trovare le funzioni
%               di base con supporto comune. Gli indici sono sequenziali,
%               ma possono essere anche logici.
%
% OUTPUTS:
%
%   supp_funs:  indici delle B-spline con supporto in comune con le B-pline
%               indicate da fun_ind.
%
% NOTE:
%   
%   1. In questo caso siccome l'operazione non può essere parallelizzata ma
%   necessita di essere svolta una funzione per volta, uso gli indici
%   sequenziali. Nel caso vengano forniti indici logici li converto, in
%   modo da aumentare l'interoperabilità con altri codici. Restituisco
%   indici dello stesso tipo di quello dati in input per lo stesso motivo. 

logical_index=false;
if islogical(fun_ind)
    fun_ind=find(fun_ind);  % converto gli indici logici
    logical_index=true;
end

supp_funs=[];
for fundx=fun_ind
    selected=fundx; % inizio aggiungendo la presente.
    % L'operazione viene svolta una funzione per volta, seleziono quindi ad
    % ogni iterazione la funzioen con indice fundx fra quelle date.
    knots_ind=space.get_knots(fundx);
    knots=space.knots(knots_ind); % leggo i nodi toccati da fundx
    knots_ind=find(knots_ind);
    
    v=[1:knots_ind(1)-1];   % seleziona i nodi antecedenti ala funzione 
    pm=-1;   % questo parametro esprime se si seleziona in avanti o indietro
    
    for check=knots([1,end])
        % Il numero di altre funzioni che hanno supporto nel supporto di
        % quella selezionata è
        others=nnz(space.knots(v)==check);  
        for add=1:others
            selected=union(selected,fundx+pm*add);
        end
        % Alla prossima iterazione controllo i nodi successivi la funzione
        % selezionata
        v=[knots_ind(end)+1:numel(space.knots)];
        % e eventualmente devo agigungere indici successivi a quello della
        % funzione attuale, quindi 
        pm=1;
        
    end
    supp_funs=union(supp_funs, selected);
end

% Ore, se le funzioni sleezionate distano per meno di p, i loro domini si
% toccano e pertanto anche tutte le funzioni in mezzo hanno
% complessivamente supporto contenuto nelle funzioni selezionate da fun_ind

dist=diff(supp_funs);
near_cpls= 1 < dist & dist <= space.deg+1;
near_cpls=find(near_cpls);

for cpl=near_cpls
    supp_funs=union(supp_funs, supp_funs(cpl):supp_funs(cpl+1));
end

if logical_index
    % Se necessario restituisco indici logici per migliore interfaccia con
    % il resto dei codici. 
    supp_funs=ismember(1:space.dim,supp_funs);
    return
end

supp_funs=reshape(supp_funs,1,[]);

end
