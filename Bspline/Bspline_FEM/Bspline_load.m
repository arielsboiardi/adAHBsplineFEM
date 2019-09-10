function F=Bspline_load(space,probdata)
% Bspline_load: Costruisce il vettore di carico per il problema probdata
% rispetto al Bspline_space probdata.
%
%   F=Bspline_laod(space,probdata)
%
% INPUTS:
%
%   space: Bspline_space
%   probdata: problem_data_set
%
% OUTPUTS:
%
%   F: vettore di carico nel Bspline_space space
%

% Estragga i parametri per accesso più veloce e facilità di scrittura
m=probdata.m; b=probdata.b;
Xi=space.knots;
n=space.dim; p=space.deg;

F=zeros(n-2,1);

for idx=1:p
    fint=@(t) (m*space.dBspline_eval(1,t) .* ...
                space.dBspline_eval(idx+1,t) + ...
               b*space.dBspline_eval(1,t) .* ...
                space.Bspline_eval(idx+1,t))*probdata.u0;
    F(idx)=-integral(fint,Xi(1),Xi(p+2));
end
for idx=n-2-p:n-2
    fint=@(t) (m*space.dBspline_eval(n,t) .* ...
                space.dBspline_eval(idx+1,t) + ...
               b*space.dBspline_eval(n,t) .* ...
                space.Bspline_eval(idx+1,t))*probdata.uL;
    F(idx)=-integral(fint,Xi(end-p-2),Xi(end));
end

% Nel caso non sia necessario sarebbe bello evitare di calcolare il termine
% noto devouto al forzante. In particolare se il forzante è nullo non serve
% effettuale l'integrazione. 
rand_points=probdata.Omega(1)+(probdata.Omega(2)-probdata.Omega(1))*rand(1,100);
if nnz(probdata.f(rand_points))==0 
    return
end

for jdx=1:n-2
    fint=@(t) probdata.f(t).*space.Bspline_eval(jdx+1,t);
    F(jdx)=F(jdx)+integral(fint,Xi(jdx+1),Xi(jdx+p+2));
end


end

