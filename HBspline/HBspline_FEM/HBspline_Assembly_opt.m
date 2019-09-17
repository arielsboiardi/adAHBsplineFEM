function M=HBspline_Assembly_opt(hspace, probdata)
% HBspline_Assembly costruisce la matrice di rigidezza per il problema
% probdata nello spazio gerarchico definito dal HBspline_space, hspace.
%
%   A=HBspline_Assembly(hspace, probdata)
%
% INPUTS:
%
%   hspace:     HBspline_space contenente la descrizione dello spazio
%               gerarchico in cui si vuole approssimare il problema (vedi
%               classe HBspline_space)
%   probdata:   problem_data_set contente le informazioni sul problema da
%               risolvere (vedi classe)
%
% OUTPUTS:
%
%   A:          matrice di rigidezza per la discretizzazione dle problema
%               nello spazio gerarchico dato
%

L=hspace.nlev;  % salvo per semplicità di accesso
A=hspace.A; % indici delle B-spline attive per livello
p=hspace.deg;
e1=1; e2=p+2;

M=zeros(hspace.dim-2);  % inizializzo

idx=1; % indice di riga 
for lc=1:L  % scorro tutti i livelli
    
    space_lc=hspace.sp_lev{lc}; % salvo lo spazio del livello lc
    A_lc=A{lc}; % estraggo le B-splines attive del livello lc:
    A_lc(1)=false; A_lc(end)=false; % escluse al prima e l'ultima
    A_lc=find(A_lc); % miglioro velocità
    
    for ilc=A_lc % scorro le funzioni attive a livello lc
        
        % ESTRAGGO i nodi di supporto alla B-spline attiva selezionata:
        ilc_knots=space_lc.knots(space_lc.get_knots(ilc));
        
        jdx=1; % indice di colonna
        % Per ogni B-spline attiva ilc a livello lc scorro tutti i livelli
        % e tutte le funzioni attive per ogni livello. 
        for lr=1:L
            A_lr=A{lr}; A_lr(1)=false; A_lr(end)=false;
            A_lr_log=A_lr; 
            % Lo salvo perché Bspline_space\get_knots è più efficiente per
            % input logici.
            A_lr=find(A_lr);
            
            if numel(A_lr)>0 % procedo solo se ci sono funzioni attive
                space_lr=hspace.sp_lev{lr}; 
                % Estraggo lo spazio dopo il controllo perché l'accesso ai
                % campi della è costoso-
              
                % CONTROLLO che almeno una delle B-splines attive a livello
                % lr abia supporto in comune con la B-spline ilc
                % selezionata: 
                act_knots_lr=space_lr.knots(space_lr.get_knots(A_lr_log));
                if min(ilc_knots(e2),act_knots_lr(end))-max(ilc_knots(e1),act_knots_lr(e1))>0
                    % SE qualche B-spline a supporto in comune con ilc,
                    % procedo scorrendo tutte le B-splines attive del
                    % livello lr, saltando però quelle che non hanno
                    % supporto in comune con la B-spline ilc:
                    for jlr=A_lr
                        jlr_knots=space_lr.knots(space_lr.get_knots(jlr));
                        if min(ilc_knots(e2),jlr_knots(e2))-max(ilc_knots(e1),jlr_knots(e1))>0
                            M(idx,jdx)=hspace.a_bilin(lr,jlr,lc,ilc,probdata);
                        end
                        jdx=jdx+1;
                    end
                else
                    jdx=jdx+numel(A_lr);
                end
            end
        end
        idx=idx+1;
    end
end

