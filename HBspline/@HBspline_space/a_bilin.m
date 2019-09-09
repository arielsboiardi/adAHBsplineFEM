function a=a_bilin(hspace, Li, idx, Lj, jdx, probdata)
% a_bilin calcola sulle funzioni idx e jdx dei livelli Li Lj
% rispettivamente dello spazio gerarchico hspace la forma bilineare
% associata alla formulazione debole del problema di trasporto diffusione
% descritto da probdata.
%
%   a=a_bilin(hspace, Li, idx, Lj, jdx, probdata)
%
% INPUTS:
%
%   hspace:     Bspline_space in cui eseguire l'operazione
%   Li:         indice del livello della prima funzione 
%   idx:        indice della prima funzioen nel livello Li
%   Lj:         indice del livello del secondo operando
%   jdx:        idnice del secondo operando nel livello Lj
%   probdata:   problem_data_set con le informazioni del problema
%
% OUTPUTS:
%
%   a:          valore della forma bilineare associata al problema di
%               trasposto e diffusione probdata calcolata sulle funzioni
%               idx del livello Li e jdx del livello Lj rispettivamente
%               dello spazio gerarchico hspace
%
%

% NOTE PERSONALI:
%   
%   1. Sarebbe bello riscriverla in modo da restringere il più possibile il
%   dominio
%   2. Usare l'indicazzazione diretta invece che glil indici di livello e
%   funzione nel livello??? 

m=probdata.m; b=probdata.b;

p=hspace.deg;

spacei=hspace.sp_lev{Li};
Xi=spacei.knots(spacei.get_knots(idx));
spacej=hspace.sp_lev{Lj};
Xj=spacej.knots(spacej.get_knots(jdx));

x1=max(Xi(1),Xj(1));
x2=min(Xi(end),Xj(end));

% Costruisco l'integranda della forma bilineare
F = @(t)    m*spacei.dBspline_eval(idx,t) .* spacej.dBspline_eval(jdx,t) + ...
            b*spacei.dBspline_eval(idx,t) .* spacej.Bspline_eval(jdx,t);

        
        %%%%%%%% ASSOLUTAMENTE MIGLIORARE QUESTO ASPETTO %%%%%%%%
        
% xi1=max(Xi1(idx), Xi2(jdx));  %%%%%% NON SO SE SIA CORRETTO
% xi2=min(Xi1(idx+p+1), Xi2(jdx+p+1));
% 
% xi1=Xi1(idx);
% xi2=Xi1(idx+p+1);
% % 
% 
% xi1=0;
% xi2=1;

a=integral(F,x1,x2);

end