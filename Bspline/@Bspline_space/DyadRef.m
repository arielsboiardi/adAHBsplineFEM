function space_ref = DyadRef(space)
% DYADREF costruisce un nuovo Bspline_space ottenuto mediante bisezione del
% vettore di nodi di space.
%
%   space_ref = DyadRef(space)
%
% INPUTS:
%
%   space: Bspline_space da raffinare
%
% OUTPUTS:
%
%   space_ref: Bspline_space raffinato
%
p=space.deg;
Xi=space.knots;

kdx=1;
for jdx=1:numel(Xi)-1
    Xi1(kdx)=Xi(jdx);
    h=Xi(jdx+1)-Xi(jdx);
    if h>0
        Xi1(kdx+1)=Xi(jdx)+h*0.5;
        kdx=kdx+1;
    end
    kdx=kdx+1;
end
space_ref=Bspline_space(space.deg,Xi1(p+1:end-p+1));
end

