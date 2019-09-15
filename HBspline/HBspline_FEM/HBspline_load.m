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

%   ========== PARTE dovuta ai DATI AL BORDO ==========
u0=probdata.u0; uL=probdata.uL;
[bdlev1, bdind1]=hspace.get_bd_function(1);
[bdlev2, bdind2]=hspace.get_bd_function('last');

rdx=1;
for l=1:L
    Al=find(hspace.A{l});
    Al=setdiff(Al,[1,hspace.sp_lev{l}.dim]);
    for adx=Al 
        F(rdx)=F(rdx)-u0*hspace.a_bilin(bdlev1,bdind1,l,adx,probdata) ...
                     -uL*hspace.a_bilin(bdlev2,bdind2,l,adx,probdata);
        rdx=rdx+1;
    end
end

%   ========== Parte dovuta al termine noto ==========
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
