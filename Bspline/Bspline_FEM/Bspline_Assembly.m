function A=Bspline_Assembly(space,probdata)
% Bspline_Assembly: Costruisce la matrice di rigidezza rispetto al
% Bspline_space space per il problema probdata.
%
%   A=Bspline_Assembly(space,probdata)
%
% INPUTS:
%
%   space: Bspline_space,si veda la guida della classe
%   probdata: problem_data_set, si veda ala guia della classe
%
% OUTPUTS:
%
%   A: matrice di rigidezza assemblata rispetto alla base di space
%

% Estragga i parametri per accesso più veloce e facilità di scrittura
m=probdata.m; b=probdata.b;
Xi=space.knots;
n=space.dim; p=space.deg;

A=zeros(n-2,n-2); % assegno per ottimizzare velocità
for idx=1:n-2
    for jdx=idx-p:idx+p
        if (jdx>=1) && (jdx<=n-2)
            x1=max(Xi(idx+1),Xi(jdx+1));
            x2=min(Xi(idx+p+2),Xi(jdx+p+2));
            % Costruisco l'integranda della forma bilineare
            F = @(t) m*space.dBspline_eval(idx+1,t) .* ...
                space.dBspline_eval(jdx+1,t) + ...
                b*space.dBspline_eval(idx+1,t) .* ...
                space.Bspline_eval(jdx+1,t);
            % Calolo l'integrale con la routine di MATLAB
            A(jdx,idx)=integral(F,x1,x2);
            
        end
    end
end

end
