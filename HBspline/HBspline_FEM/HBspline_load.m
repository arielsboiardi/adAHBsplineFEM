function F=HBspline_load(hspace, probdata)
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

%% Parte dovuta ai dati di bordo
bd_values=[probdata.u0, probdata.uL];   % straggo i valori al bordo
if nnz(bd_values)>0
    disp('ci sono dati di bordo')
    ext1=1; ext2=p+2;    % servono per tenere conto del dato di bordo in esame fra i due giri del ciclo
    % Procedo alle stesse operazioni per entrambi i dati di bordo
    for bdv=bd_values
        if bdv~=0
            disp(strcat('Il dato a bordo vale ',num2str(bdv)))
            % In base a quele valore di bordo sto usando devo fare una
            % diversa selezione nella funzione terminale dello spazio. Si
            % veda i dettagli in HBspline_space\get_bd_function
            if find(bd_values==bdv)==1
                dir=1
                selection=1;
            else
                dir=-1
                selection='last';
            end
            [bdlev, bdind]=hspace.get_bd_function(selection); % coordinate della funzioen terminale relativa al dato al bordo nello spazio gerarchico
            bd_fun_knots_ind=hspace.sp_lev{bdlev}.get_knots(bdind); % trovo i nodi di supporto della funzione di bordo
            bd_fun_knots=hspace.sp_lev{bdlev}.knots(bd_fun_knots_ind);
            rdx=1;  % indice dell'elemento del vettore F che sto scrivendo
            for l=1:L
                % Ora scorro su tutte le funzioni dello spazio gerarchico
                % in ordine per livello e integro contro la funzione di
                % bordo selezionata quelle che hanno supporto ad
                % intersezione non nulla con il supporto della stessa.
                
                % Controllo che nel livello selezionato ci siano funzioni
                % attive in cui supporto ha intersezione non vuota con il
                % supporto della funzione di bordo
                spacel=hspace.sp_lev{l};    % spazio a livello attuale
                act_knots_ind=spacel.get_knots(hspace.A{l});
                act_knots=spacel.knots(act_knots_ind);
                if act_knots(ext1)<bd_fun_knots(ext2)
                    % Se ci sono funzioni attive a livello L con supporto a
                    % intersezione non vuota con quello della funzione di
                    % bordo, scorro tutte le funzioni del livello attivo
                    active_ind_l=setdiff(find(hspace.A{l}),[1,spacel.dim]);
                    if dir==-1
                        % Se sono al dato di bordo finale, conviene
                        % iniziare la ricerca dall'ultima funzione del
                        % livello attuale
                        active_ind_l=flip(active_ind_l);
                        rdx=hspace.dim-2;
                    end
                    for adx=active_ind_l
                        adx_knots_ind=spacel.get_knots(adx);
                        adx_knots=spacel.knots(adx_knots_ind);
                        % Se il supporto della funzione selezionata ha
                        % intersezione non vuota con quello della funzioen
                        % di bordo procedo. 
                        % Poiché per come ho effettuato la ricerca, se una
                        % funzione ha supporto e intersezione nulla con il
                        % bordo, anche tutte le successiva hanno la stessa
                        % proprietà, 
                        if adx_knots(ext1)<bd_fun_knots(ext2)
                            % se i supporto si intersecano integro
%                             F(rdx)=F(rdx)+hspace.a_bilin(1,adx,bdlev,bdind, probdata);
                            F(rdx)=F(rdx)-bdv*hspace.a_bilin(bdlev,bdind,1,adx, probdata);
                            rdx=rdx+dir;
                        else
                            % in caso contrario posso direttamente
                            % smetterre di controllare tutte le funzioni
                            % del livello presente.
                            break
                        end
                    end
                end
            end
        end
    end
end

%% Parte dovuta al termine noto
% Faccio un controllo: se il termine noto/forzante è con alta probabilità
% nullo (a occhio) evito di eseguire l'integrazione, altrimenti proseguo.
rand_points=probdata.Omega(1)+(probdata.Omega(2)-probdata.Omega(1))*rand(1,100);
if nnz(probdata.f(rand_points))~=0
    rdx=1;
    for l=1:L
        spacel=hspace.sp_lev{l};
        for adx=setdiff(find(hspace.A{l}),[1,spacel.dim])
            adx_knots_ind=spacel.get_knots(adx);   % trovo i nodi su cui poggia la funzione attiva attuale
            adx_knots=spacel.knots(adx_knots_ind);
            x1=adx_knots(1); x2=adx_knots(p+2);   % integro solo sul supporto della funzione attive
            fnint=@(t) probdata.f(t).*hspace.sp_lev{l}.Bspline_eval(adx,t);
            F(rdx)=F(rdx)+integral(fnint,x1,x2);
            rdx=rdx+1;
        end
    end
end

end