function hspace_ref=refine(hspace, marked_fun)
% refine raffina lo spazio gerarchico hspace disattivando le funzioni
% marcate marked_fun e sostituendole con opportune funzioni del livello
% successivo all'ultimo attivo. 
%
%   hspace_ref=refine(hspace, marked_fun)
%
% INPUTS:
%
%   hspace:     HBspline_space da raffinare
%   marked_fun: indici logici delle funzioni da raffinare
%
% OUTPUTS:
%   
%   hspace_ref: raffinamento dello spazio hspace ottenuto aggiungengo un
%               livello ottenuto per bisezione del vettore dei nodi e
%               attivando in questo livello le funzioni figlie delle
%               funzioni disattivate al livello precedente. 
%

L=hspace.nlev;  % livello attuale
if ~islogical(marked_fun)
    marked_fun=ismember(1:hspace.sp_lev{L}.dim,marked_fun);
    % Sulla scelta di mantenere indici logici vedere la descrizione della
    % classe HBspline_space.
end

% Aggiungo alle funzioni marcate quelle che condividono il supporto con
% quelle marcate.
marked_fun=hspace.sp_lev{L}.get_supported_functions(marked_fun);

%% Agggiorno livello attuale
hspace_ref=hspace; % iniziamo dallo spazio dato 
hspace_ref.D{L}=hspace.D{L} | marked_fun; % disattivo le funzioni marcate
hspace_ref.A{L}=hspace.A{L} & ~marked_fun; % e le tolgo da quelle attive

space1=hspace.sp_lev{L};
hspace_ref.hcells{L}=hspace.hcells{L} & ~space1.get_cells(marked_fun);
cells=hspace_ref.hcells{L}; % estraggo per comodità di notazione
hspace_ref.hknots{L}=[cells, cells(end)] | [cells(1), cells];

%% Aggiungo livello successivo
L=L+1; % incremento il numero dei livelli 
hspace_ref.nlev=L; 

% Il nuovo livello da aggiungere si ottiene come raffinamento diadico
% uniforme dell'ultimo livello dello spazio gerarchico:
space1=space1.DyadRef;
hspace_ref.sp_lev{L}=space1; 

% Le funzioni da attivare al nuovo livello sono le figlie di quelle tolte
% dal livello precedente:
C=hspace.get_children(marked_fun); % figlie delle B-splines aggiunte
% Converto gli indici in indici logici, come previsto dalla definizione
% della classe HBspline_space
A_L_log=ismember(1:space1.dim,C); 
hspace_ref.A{L}=A_L_log;
% Tutte le funzioni non attive al nuovo livello sono disattive:
hspace_ref.D{L}=~hspace_ref.A{L}; 

hspace_ref.hcells{L}=space1.get_cells(A_L_log);
cells=hspace_ref.hcells{L}; % estraggo per comodità di notazione
hspace_ref.hknots{L}=[cells, cells(end)] | [cells(1), cells];

% La dimensione dello spazio raffinato è la dimensione dello spazio
% iniziale cui si togglie il numero di funzioni disattivale a livello L e
% si aggiunge il numero di funzioni attivate al livello L+1:
hspace_ref.dim=hspace.dim-nnz(marked_fun)+nnz(hspace_ref.A{L});

end
