function etaR=LocalRes(uh, problem_data, space)
% LocalRes : Calcola il residuo locale dell'approssimazione della soluzione
% del problema problem_data nello spazio space
%
% INPUTS:
%
%   uh: coefficienti della soluzione approssimata del problema
%   problem_data: dati del problema (si veda la classe dedicata)
%   space: spazio di approssimazione (si veda la classe dedicata)
%
% OUTPUTS:
%
%   etaR: vettore di residui locali
%

b=problem_data.b;   % Leggo i dati
m=problem_data.m;
f=problem_data.f;
u0=problem_data.u0;
uL=problem_data.uL;
Xi=space.knots;
H=diff(Xi); % calcolo le ampiezz degli intervalli delimitati dai nodi
N=numel(H);

etaR=zeros(1,N); % inizializzo 

% Costruisco la funzione da integrare una volta per tutte, poi verrà
% integrata sugli internodi come da trattazione teorica.
bd=[problem_data.u0, zeros(1, space.dim-2), problem_data.uL];
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
