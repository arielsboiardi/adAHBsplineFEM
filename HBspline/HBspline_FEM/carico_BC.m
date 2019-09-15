%   ========== PARTE dovuta ai DATI AL BORDO ==========
bd_values=[probdata.u0, probdata.uL];   % estraggo i valori al bordo
if nnz(bd_values)>0
    % ===== PROCEDO sui due valori di bordo alle medesime operazioni =====
    
    % Per il primo dato al bordo procediamo dall'inizio del vettore F fino
    % alla fine, e analogamente procediamo dalla prima all'ultima funzione
    % attiva del livello, pertanto fissiamo il parametro dir=1.
    % Analogamente l'intervallo su cui una funzione � attiva viene
    % considerato dal primo neodo ext1=1 all'ultimo ext2=p+2 su cui la
    % funzione ha supporto.
    % La funzione di bordo selezionata sar� naturalmente la prima
    % (selection=1; per dattagli sul meccanismo di selezione si rimanda al
    % metodo HBspline_space\get_bd_function).
    dir=1; % dierezione di compilazione del vettore F
    rdx=1; % indice dell'elemento del vettore F che sto calcolando
    ext1=1; ext2=p+2;
    selection=1;
    
    for bdv=bd_values
        % Se il dato al bordo selezionato � non nullo, ha senso procedere
        % con il calcolo del suo contributo nel vettore di carico:
        if bdv~=0
            % RICAVO la funzione di base corrispondente al dato di bordo
            % attuale:
            [bdlev, bdind]=hspace.get_bd_function(selection);
            bd_fun_knots_ind=hspace.sp_lev{bdlev}.get_knots(bdind);
            bd_fun_knots=hspace.sp_lev{bdlev}.knots(bd_fun_knots_ind);
            % Ho quindi ricavato i nodi su cui poggia la funzione di base
            % terminale corripsondente al dato al bordo selezionato
            
            %   ===== Calcolo il prodotto scalare con le funzioni =====
            %   =====          dello spazio gerarchico            =====
            %
            % Scorro su tutte le funzioni dello spazio gerarchico
            % in ordine per livello e integro contro la funzione di
            % bordo selezionata quelle che hanno supporto ad
            % intersezione non nulla con il supporto della stessa.
            
            for l=1:L
                % Estraggo le funzioni attive al livello l
                Al=hspace.A{l};
                % Se non ci sono funzioni attive al livello attuale �
                % inutile procedere, controllo quindi :
                if nnz(Al)>0
                    
                    % CONTROLLO che nel livello l selezionato ci siano
                    % funzioni attive in cui supporto ha intersezione non
                    % vuota con il supporto della funzione di bordo
                    spacel=hspace.sp_lev{l};    % spazio a livello attuale
                    act_knots_ind=spacel.get_knots(Al);
                    act_knots=spacel.knots(act_knots_ind);
                    % Sono cos� estratti i nodi cu sui poggiano TUTTE le
                    % funzioni attive del livello l selezionato
                    
                    if dir==-1
                        % Se siamo all'ultima funzione di base, il dominio
                        % di intergrazione va dal primo nodo alla funzione
                        % la bordo, all'ultimo nodo dall'ultima funzione
                        % attiva.
                        ext1=numel(act_knots);
                        ext2=1;
                    end
                    
                    if dir*act_knots(ext1)<dir*bd_fun_knots(ext2)
                        % Se ci sono funzioni attive a livello l con supporto a
                        % intersezione non vuota con quello della funzione di
                        % bordo, scorro tutte le funzioni attive del livello
                        % attuale l, ESCLUSE la prima e l'ultima nel caso
                        % siano attive.
                        active_ind_l=setdiff(find(Al),[1,spacel.dim]);
                        
                        % ext1=1; ext2=p+2; %==== ELIMINARE ?????
                        if dir==-1
                            % Se sono al dato di bordo finale, conviene
                            % iniziare la ricerca dall'ultima funzione del
                            % livello attuale e riempio il vettore dal
                            % fondo.
                            active_ind_l=flip(active_ind_l);
                            %                             rdx=hspace.dim-2;
                            ext1=p+2; ext2=1;
                        end
                        
                        % SCORRO  tutte le funzioni attive a livello l
                        for adx=active_ind_l
                            
                            adx_knots_ind=spacel.get_knots(adx);
                            adx_knots=spacel.knots(adx_knots_ind);
                            
                            % CONTROLLO che la funzione attiva selezione
                            % adx abbiamo supporto ad intersezione non
                            % vuota con la funzione id bordo attuale:
                            if dir*adx_knots(ext1)<dir*bd_fun_knots(ext2)
                                % SE i supporto si intersecano, calcolo il
                                % contributo nel vettore di carico come
                                % previsto dai calcoli nel report teorico.
                                F(rdx)=F(rdx)-bdv*hspace.a_bilin(bdlev,bdind,l,adx, probdata);
                                rdx=rdx+dir;
                            else
                                % IN CASO CONTRARIO posso direttamente
                                % smetterre di controllare tutte le altre
                                % funzioni del livello presente
                                % active_ind_l, in quanto ogni funzione
                                % successiva avr� supporto traslato di una
                                % cella. Passo quindi al prossimo livello.
                                break
                            end
                        end
                    end
                end
            end
        end
        % TERMINATO il primo giro la selezione passer� al dato di bordo
        % terminale e pertanto sar� necessario selezionare l'ultiuma
        % funzione terminale (selection='last'). Inoltre in questo caso
        % scorreremo le funzioni attive in ogni livello a partire
        % dall'ultima, compilando quindi il vettore di carico dall'ultimo
        % elemento a ritroso (dir=-1). Inoltre il parametro dir viene usato
        % come controllo del giro del ciclo sui due dati di bordo e il suo
        % segno per aggiustare le disuguagliazne che nel caso dell'ultimo
        % dato al bordo devono essere ribaltate.
        selection='last';
        rdx=hspace.dim-2;
        dir=-1;
    end
end