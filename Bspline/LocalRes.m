function etaR=LocalRes(uh, probdata, space)
% LocalRes : Calcola il residuo locale dell'approssimazione della soluzione
% del problema probdata nello spazio space
%
% INPUTS:
%
%   uh: coefficienti della soluzione approssimata del problema
%   probdata: dati del problema (si veda la classe problem_data_set)
%   space: spazio di approssimazione (si veda la classe Bspline_space)
%
% OUTPUTS:
%
%   etaR: vettore di residui locali
%

b=probdata.b;   % Leggo i dati
m=probdata.m;
f=probdata.f;
u0=probdata.u0;
uL=probdata.uL;
Xi=space.knots;
H=diff(Xi); % calcolo le ampiezz degli intervalli delimitati dai nodi
N=numel(H);

etaR=zeros(1,N); % inizializzo 

% Costruisco la funzione da integrare una volta per tutte, poi verrà
% integrata sugli internodi come da trattazione teorica.
bd=[probdata.u0, zeros(1, space.dim-2), probdata.uL];
% Questi sono i coefficienti del rilevamento dei dati al bordo nello
% spazio space.
% La soluzione invece è da considerarsi omogenea, pertanto:
uh(1)=0; uh(end)=0;

F=@(t) ( f(t) + ...
    m*(space.ddBspline_appr(bd,t) +  space.ddBspline_appr(uh,t)) - ...
    b*(space.dBspline_appr(bd,t) +  space.dBspline_appr(uh,t)) ).^2;

for kdx=1:N
    Q=0;
    if H(kdx)~= 0
        % Inutile calcolare gli integrali per intervalli nulli.
        Q=sqrt(integral(F,Xi(kdx),Xi(kdx+1)));
    end
    etaR(kdx)=H(kdx)*Q;
end
end
