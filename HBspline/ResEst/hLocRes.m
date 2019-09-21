function etaR=hLocRes(uh,probdata, hspace, etaR_prec)
% hLocRes calcola il residuo locale dell'approssimazione uh del problema
% probdata al livello più profondo dello spazio gerarhcico hspace. Se viene
% dato etaR_prec, cell array contente il reisudo fino al penultimo livello,
% aggiunge un livello con il residuo appena calcolato.
%
%   etaR_L=hLocRes_L(uh,probdata, hspace, etaR_prec)
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
u0=probdata.u0;
u1=probdata.uL;

L=hspace.nlev; % massima profondità dello spazio gerarhcico
act_cells=hspace.hcells{L}; % celle attive all'ultimo livello

%% Calcolo il residuo sule celle attive dell'ultimo livello disponibile
spaceL=hspace.sp_lev{L}; % estraggo lo spazio dell'ultimo livello
Xi=spaceL.knots; % nodi
H=diff(Xi); % celle
N=numel(H); %

etaR=zeros(1,N); % inizializzo

% Dichiero la funzione che definisce il residuo, come mostrato nella
% trattazione teorica
uh(1)=0; uh(end)=0; % considero la soluzione omogenea
bd=[probdata.u0, zeros(1, spaceL.dim-2), probdata.uL];

F=@(t) ( f(t) + ...
    m*(spaceL.ddBspline_appr(bd,t)  +  hspace.HBspline_appr(uh,t,2)) - ...
    b*(spaceL.dBspline_appr(bd,t)   +  hspace.HBspline_appr(uh,t,1)) ).^2;

for jdx=1:N
    % Poiché ogni elemento del vettore dei residui etaR che sto calcolando
    % richiede una quadratura numerica, conviene eseguire i calcoli solo
    % sulle celle attive:
    if act_cells(jdx) && H(jdx)~=0
        etaR(jdx)=H(jdx)*sqrt(integral(F,Xi(jdx),Xi(jdx+1)));
    end
end
etaRc{1}=etaR;
etaR=etaRc;

if nargin==4
    % Se viene dato come input una gerarchia di residui, aggiungo il vettore
    % appena calcolato come ultimo livello, ammesso che questo sia
    % comaptibile con le dimensioni e la profondità di hspace.
    if numel(etaR_prec)~=L-1
        error("Residui non compatibili con lo spazio");
    end
    % Dall'ultimo residuo disponibile in etaR_prec azzero gli elementi
    % corrispondenti alla celle disattivate al livello L-1:
    etaR_prec{L-1}=etaR_prec{L-1}.*hspace.hcells{L-1};
    
    etaR_prec{L}=etaR{1};  % salvo etaR come ultimo livello
    etaR=etaR_prec;
end
end
