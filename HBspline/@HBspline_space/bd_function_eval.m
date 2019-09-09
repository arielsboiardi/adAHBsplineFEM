function bd=bd_function_eval(hspace, index, t, deriv)
% bd_function_eval valuta in t la funzione di bordo dello spazio gerarchico
% hspace indicizzata da index, in particolare troveremo la prima Bspline
% con index=1 e l'ultima con index='last'. Se specificato, può essere
% richiesta la derivata fino all'oridne 2.
%
%   bd=bd_function_eval(hspace, index, t)
%
% INPUTS:
%
%   hspace: spazio gerarchico in cui cerchiamo 
%   index:  indice della funzione da cercare, in particolare:
%               - 1 per la prima B-spline (interpolante nel primo nodo)
%               - 'last' per l'ultima (interpolante in fondo al dominio)
%   t:      punto di valutazione della funzione cercata
%   deriv:  eventuale ordine di derivazione della funzione cercata
%
% OUTPUTS:
%   
%   bd:         valore della funzione cercata in t
%
% NOTE:
% La fucntion, per come costruita, permette di cercare fra i liveli dello
% spazio gerarchico una funzione con indice qualsiasi, il nome della
% function non è quindi stato scelto per la sua operabilità ma più per il
% suo utilizzo più probabile, in quanto non troviamo usi a cercare funzioni
% di base diverse da quelle terminali.
%

if nargin<4
    deriv=0;
end

last=false;
if strcmp(index,'last')
    last=true;
end

% In base all'ordine di derivazioen richiesto bisogna chiamare un diverso
% metodo della classe Bspline_space per la valutazione della funzione.
% Costruisco quindi il nome del metodo opportuno
eval_method=strcat(repmat('d',1,deriv),'Bspline_eval');


for L=1:hspace.nlev     % scorro su tutti i livelli
    if last
        index=hspace.sp_lev{L}.dim;
    end
    if hspace.A{L}(index)   % è attiva la prima funzione del livello L
        bd=feval(eval_method,hspace.sp_lev{L},index,t);
    end
end
end
    