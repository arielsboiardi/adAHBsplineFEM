classdef problem_data_set
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
        % Costruttore
        function probdata=problem_data_set(Omega,b,m,u0,uL,f,varargin)
            % Costruise una variabile di tipo problem_data_set contentente
            % le informazioni assegnate. I due input con la soluzione sono
            % costruiti come facoltativi, ma sarebbero opportuni.
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
