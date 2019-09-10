function M=HBspline_Assembly(hspace, probdata)
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
L=hspace.nlev;  % salvo per migliore accesso
A=hspace.A;

% A=zeros(hspace.dim);
idx=1;
for lr=1:L
    for jlr=find(A{lr})
        if (jlr~=1) && (jlr~=hspace.sp_lev{lr}.dim)
            jdx=1;
            for lc=1:L
                for ilc=find(A{lc})
                    if (ilc~=1) && (ilc~=hspace.sp_lev{lc}.dim)
                        M(jdx,idx)=hspace.a_bilin(lr,jlr,lc,ilc,probdata);
                        jdx=jdx+1;
                    end
                end
            end
            idx=idx+1;
        end
    end
end

