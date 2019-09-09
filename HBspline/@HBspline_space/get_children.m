function C=get_children(hspace,fun_ind)
% get_children determina gli indici delle funzioni di base del livello
% successivo figlie delle funzioni della base del livello attuale
% identificate dagli indici fun_ind
%
%   C=get_children(lev,fun_ind)
%
% INPUTS
%
%   hspace:     HBspline_space
%   fun_ind:    indici delle funzioni di base a livello attuuale di cui si
%               vogliono calcolare le figlie
%
% OUTPUTS:
%
%   C:          indici delle funzioni della base a figlie delle funzioni di
%               base fun_ind 
%
% Attenzione:   tutti i livelli sono ottenuti mediante raffinamento
% diadico, come stabilito dalle regole di raffinamento della classe
% Bspline_soace e HBspline_space. Le relazione fra i livelli impiegata in
% questa function è valida esclusivamente in questo caso, motivo per cui si
% è scelto di includerla come memtodo della classe e non come function
% autonoma. 

% Questa operazione potrebbe anche essere svolta usando la matrice di
% connettività, ma siccome ll'operazione non è ovvia proviamo prima a fare
% tutto più atriginalmente. Nel caso si riuscisse a costruire un metodo con
% la matrice di connettività questa function potrebbe essere
% rimpiazzata/riscritta.

p=hspace.deg;       % inizio leggendo il grado per velocità di accesso

% Dalla relazione a due livelli [Hollig: Finite element mathods with
% B-splines] 

if islogical(fun_ind)
    % Siccome in molti casi traccio gli elementi marcati in vettori logici
    % è conveniente incluedere questo caso
    fun_ind=find(fun_ind);
end

C=2*fun_ind;
C1=C;
for pdx=1:p+2
    C=union(C,C1+pdx-(p+2));
    % Rispetto alla formula della fonte citata ho dovuto traslare gli
    % indici di p+2. La traslazione di p indici è dovuta al fatto che nel
    % raffinamento non biseco i nodi ripetuti all'inizio e alla fine per
    % facilità di indicizzazione delle funzioni. La traslazione di 2 è
    % dovuta al fatto che ho indicizzato le funzioni da 1 e non da 0,
    % quindi devo tornare indietro di 2*(1-0).
end
end