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

hspace_ref=hspace; % iniziamo dallo spazio dato 
hspace_ref.D{L}=hspace.D{L} | marked_fun;   % disattivo le funzioni marcate
hspace_ref.A{L}=hspace.A{L} & ~marked_fun;  % e le tolgo da quelle attive
%=?=% A questo punto mi pare che A e D abbiano più una funzione di controllo
%=?=% l'uno dell'altro che non vera utilità in quanto in questa
%=?=% implementazione sono complementari

space1=hspace.sp_lev{L}.DyadRef;
% Ottengo il nuovo livello come raffinamento diadico mediante il metodo
% DyadRef del Bspline_space uniforma dle livello attuale

L=L+1;
hspace_ref.nlev=L;  % aggiungo un livello 
hspace_ref.sp_lev{L}=space1;    % al nuovo livello metto lo spazio uniforma raffinato

% A questo punto bisogna determinare le funzioni attive e disattive del
% nuovo livello 
C=hspace.get_children(marked_fun);
% Le funzioni attive del livello precedente sono quelle in C, cioè le
% figlie di quelle disattivate al livello precedente in questa operazione.
% ATTENZIONE: Non sono le figlie di TUTTE le funzioni non attive al ivello
% precedente!
A_l_log=ismember(1:space1.dim,C);
hspace_ref.A{L}=A_l_log;  
% Converto però C in vettore logico come previsto dalla definizione della 
% classe HBspline_space.
hspace_ref.D{L}=~hspace_ref.A{L};   % le altre sono non attive

hspace_ref.dim=hspace.dim-nnz(marked_fun)+nnz(hspace_ref.A{L});

% Costruisco la griglia gerarchica
hspace_ref.knots=union(hspace_ref.knots, space1.knots(space1.get_knots(A_l_log)));

end
