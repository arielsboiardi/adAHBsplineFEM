function etaR=hLocRes(uh,probdata, hspace)
% hLocRes calcola il residuo locale dell'approssimazione uh del problema
% probdata al livello più profondo dello spazio gerarhcico hspace. Se viene
% dato etaR_prec, cell array contente il reisudo fino al penultimo livello,
% aggiunge un livello con il residuo appena calcolato.
%
%   etaR_L=hLocRes(uh,probdata, hspace, etaR_prec)
%
% INPUTS:
%
%   uh:         coefficienti della soluzione approssimata in hspace
%   probdata:   dati del problema (classe problem_data_set)
%   hspace:     HBspline_space con le informazioni dello spazio di
%               approssimazione
%   etaR_prec:  cell array con vettori di residui locali calcolati fino al
%               penultimo livello dello spazio
%
% OUTPUTS:
%
%   etaR:       cell array che per ogni livello contiene un vettore
%               contente i residui locali calcolati sulle celle attive
%               dello spazio hspace. Sulle celle non attive troviamo 0.
%

b=probdata.b;   % Leggo i dati del problema
m=probdata.m;
f=probdata.f;


L=hspace.nlev; % massima profondità dello spazio gerarhcico

etaR=cell(L,1);
for ldx=1:L
    % Calcolo il residuo sule celle attive dell'ultimo livello disponibile
    act_space=hspace.sp_lev{ldx}; % estraggo lo spazio dell'ultimo livello
    Xi=act_space.knots; % nodi
    H=diff(Xi); % celle
    N=numel(H); %

    etaR{ldx}=zeros(1,N); % inizializzo

    % Dichiaro la funzione che definisce il residuo, come mostrato nella
    % trattazione teorica
    uh(1)=0; uh(end)=0; % considero la soluzione omogenea
    bd=[probdata.u0, zeros(1, act_space.dim-2), probdata.uL];

    F=@(t) ( f(t) + ...
        m*(act_space.ddBspline_appr(bd,t)  +  hspace.HBspline_appr(uh,t,2)) - ...
        b*(act_space.dBspline_appr(bd,t)   +  hspace.HBspline_appr(uh,t,1)) ).^2;

for jdx=find(hspace.hcells{ldx})
    % Poiché ogni elemento del vettore dei residui etaR che sto calcolando
    % richiede una quadratura numerica, conviene eseguire i calcoli solo
    % sulle celle attive:
    if H(jdx)~=0
        etaR{ldx}(jdx)=H(jdx)*sqrt(integral(F,Xi(jdx),Xi(jdx+1)));
    end
end


end
