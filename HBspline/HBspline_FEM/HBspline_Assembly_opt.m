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

M=zeros(hspace.dim-2);  % inizializzo
idx=1;
for lc=1:L
    A_lc=A{lc};
    A_lc(1)=false; A_lc(end)=false; % escludo al prima e l'ultima
    
    space_lc=hsapce.sp_lev{lc};  
    
    for ilc=find(A_lc)
        
        ilc_knots=space_lc.knots(space_lc.get_knots(ilc));
        
        jdx=1;
        for lr=1:L
            A_lr=A{lr}; A_lr(1)=false; A_lr(end)=false;
            A_lr=find(A_lr);
            
            if numel(A_lr)>0
                
                space_lr=hsapce.sp_lev{lr};
                act_knots_lr=space_lr.knots(space.lr.get_knots(A_lr));
                
                if ilc_knots(1) 
                    ilc_knots(e1)<act_knots_lr(e2) || ilc_knots(e2)>act_knots_lr(e2)
                
                for jlr=A_lr
                    M(idx,jdx)=hspace.a_bilin(lr,jlr,lc,ilc,probdata);
                    jdx=jdx+1;
                end
            end
        end
        idx=idx+1;
    end
end

