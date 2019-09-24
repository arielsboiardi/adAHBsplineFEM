classdef problem_data_set
% problem_data_set contiene le informazioni del problema di trasporto e
% diffusione.
%   Risolviamo problemi della forma:
%
%       -m * u'' + b * u' = f su Omega
%       u(Omega(1))=u0; u(Omega(2))=uL
%
%   Un oggetto di questa classe contiene tutte le informazioni del
%   problema. I dati comprendono anche, se dipsonibili, la soluzione esatta
%   del problema e la sua derivata, per valutare l'errore commesso in
%   problemi banchmark.

    properties
        Omega   % vettore 1x2 contentne estremi del dominio
        b       % parametro b del problmea
        m       % parametri mu dle problema
        u0      % valore nell'estremo sx
        uL      % valore nell'estremo dx
        f       % function handle con il termine noto
        uex     % soluzione esatta (function handle)
        duex    % derivata della soluzione esatta (function handle)
    end
    
    methods

        function probdata=problem_data_set(Omega,b,m,u0,uL,f,varargin)
            % problem_data_set costruisce un'istanza della classe.
            probdata.Omega=Omega;
            probdata.b=b;
            probdata.m=m;
            probdata.u0=u0;
            probdata.uL=uL;
            probdata.f=f;
            if nargin > 6
                probdata.uex=varargin{1};
                if nargin > 7
                    probdata.duex=varargin{2};
                end
            end
        end
    end
end
