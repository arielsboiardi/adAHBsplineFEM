function F=HBspline_load_opt(hspace, probdata)
% HBspline_load costruisce il vettore di carico per la discretizzazione del
% problema debole descritto da probdata nello spazio gerarchico hspace.
%
%   F=HBspline_load(hspace, probdata)
%
% INPUTS:
%
%   hsapce:     HBspline_space che descrive lo spazio gerarchico in cui il
%               problema viene discretizzato
%   probdata:   problem_data_set che desctrive il problema (vedere la
%               rispettiva classe)
%
% OUTPUTS:
%
%   F:          vettore di carico per il sistema lineare ottenuto dalla
%               discretizzazione del problema probdata nello spazio
%               gerarchico dato

L=hspace.nlev;   % massima profondità dello spazio gerarchico
p=hspace.deg;   % grado dello spazio
F=zeros(hspace.dim-2,1);    % inizializzazione del vettore di carico

%   ========== PARTE dovuta ai DATI AL BORDO ==========

bd_values=[probdata.u0, probdata.uL];   % estraggo i valori al bordo
if nnz(bd_values)>0
    
    % ===== DATO AL BORDO INIZIALE =====
    % la funzione di bordo selezioata à la
    % prima, per dettagli sul meccanismo di selezione
    % HBspline_space\get_bd_function:
    selection=1; % selezione della funzione di bordo (con get_bd_function)
    % Scorreremo poi i livello dal primo all'ultimo seguendo in ogni
    % livello l'ordine naturale della base dello spazio corripsondente.
    % Pertanto la compilazione del vettore F procede dall'inizio (rdx=1) e
    % in avanti:
    lev_start=1; lev_end=L;
    dir=1; % direzione di compilazione del vettore F
    rdx=1; % indice dell'elemento del vettore F che sto calcolando
    % L'intersezione del supporto di un B-spline con la funzione di bordo è
    % l'intervallo fra il primo nodo della B-spline e l'ultimo della
    % funzione di bordo:
    ext1=1; ext2=p+2; % indici dei nodi per l'intersezione
    %  ===================================
    
    for bdv=bd_values
        % Se il dato al bordo selezionato è non nullo, ha senso procedere
        % con il calcolo del suo contributo nel vettore di carico:
        if bdv~=0
            % RICAVO la funzione di base corrispondente al dato di bordo
            % attuale e i nodi del suo supporto:
            [bdlev, bdind]=hspace.get_bd_function(selection);
            bd_fun_knots_ind=hspace.sp_lev{bdlev}.get_knots(bdind);
            bd_fun_knots=hspace.sp_lev{bdlev}.knots(bd_fun_knots_ind);
            
            for l=lev_start:dir:lev_end
                % Estraggo le funzioni attive al livello l ESCLUSE la prima
                % e l'ultima
                Al=hspace.A{l};
                Al(1)=false; Al(end)=false;
                active_ind_l=find(Al);
                
                if numel(active_ind_l)>0 % procedo se ci sono fz attive
                    
                    % CONTROLLO che al livello l ci siano funzioni attive
                    % con supporto in comune con la funzione di bordo
                    
                    spacel=hspace.sp_lev{l};    % spazio a livello attuale
                    act_knots_l_ind=spacel.get_knots(Al);
                    act_knots_l=spacel.knots(act_knots_l_ind);
                    % act_knots_l sono i nodi su cui poggiano le B-splines
                    % attive del livello l (si veda
                    % Bspline_space\get_knots)
                    
                    if dir==-1
                        % Se siamo all'ultima funzione di base,
                        % l'intersezione dei domini è l'intervallo fra il
                        % primo nodo della funzione di bordo e l'ultimo
                        % nodo delle funzioni attive:
                        ext1=numel(act_knots_l);
                        ext2=1;
                    end
                    
                    if dir*act_knots_l(ext1)<dir*bd_fun_knots(ext2)
                        
                        if dir==-1
                            % Se sono al dato di bordo finale, scorriamo le
                            % funzioni attive in ordine inverso
                            active_ind_l=flip(active_ind_l);
                            % e l'intersezione dei domini è l'intervallo
                            % fra il primo nodo della funzione di bordo e
                            % l'ultimo nodo della funzione attiva
                            % selezionata:
                            ext1=p+2; ext2=1;
                        end
                        
                        % SCORRO  tutte le funzioni attive a livello l
                        for adx=active_ind_l
                            
                            % CONTROLLO che la funzione attiva selezionata
                            % adx abbia supporto in comune con la funzione
                            % di bordo:
                            adx_knots_ind=spacel.get_knots(adx);
                            adx_knots=spacel.knots(adx_knots_ind);
                            
                            if dir*adx_knots(ext1)<dir*bd_fun_knots(ext2)
                                % SE i supporto si intersecano, calcolo il
                                % contributo di adx  al vettore di carico
                                F(rdx)=F(rdx)-bdv*hspace.a_bilin(bdlev,bdind,l,adx,probdata);
                                rdx=rdx+dir;
                            else
                                % IN CASO CONTRARIO posso direttamente
                                % smetterre di controllare il livello
                                % active_ind_l, in quanto ogni B-spline
                                % successiva avrà supporto traslato di una
                                % cella.
                                % Le funzioni saltate danno contributo
                                % nullo a F, passo quindi avanti di un
                                % corrispondente numero di celle
                                rdx=rdx+dir*nnz(active_ind_l>=adx);
                                break
                            end
                        end
                    else
                        rdx=rdx+dir*numel(active_ind_l);
                    end
                end
            end
        end
        
        % termianto il primo giro la selezione passerà al
        % ===== DATO DI BORDO TERMINALE =====
        % e pertanto sarà necessario selezionare l'ultiuma funzione di
        % bordo (selection='last').
        % In questo caso i livello in ordine inverso, e così le funzioni
        % attive in ogni livello; compilando quindi il vettore di carico
        % a ritroso (dir=-1) a partire dall'ultimo elemento (rdx=numel(F)).
        selection='last';
        lev_start=L; lev_end=1;
        dir=-1;
        rdx=numel(F);
        % ===================================
        
    end
end


%   ========== PARTE dovuta al FORZANTE dell'equazione ==========

% Faccio un controllo: se il forzante è con alta probabilità nullo, non lo
% conto.
Omega=probdata.Omega;
rand_pts=Omega(1)+(Omega(2)-Omega(1))*rand(1,10*numel(hspace.sp_lev{L}.knots));
if nnz(probdata.f(rand_pts))~=0
    rdx=1;
    for l=1:L
        spacel=hspace.sp_lev{l};
        for adx=setdiff(find(hspace.A{l}),[1,spacel.dim])
            % trovo i nodi su cui poggia la funzione attiva attuale
            adx_knots_ind=spacel.get_knots(adx);
            adx_knots=spacel.knots(adx_knots_ind);
            % integro solo sul supporto della funzione attive
            x1=adx_knots(1); x2=adx_knots(p+2);
            fnint=@(t) probdata.f(t).*hspace.sp_lev{l}.Bspline_eval(adx,t);
            F(rdx)=F(rdx)+integral(fnint,x1,x2);
            rdx=rdx+1;
        end
    end
end

end
