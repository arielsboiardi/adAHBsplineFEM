function subdivision_plot(space, f_ind)
% subdivision_plot plots the subdivision of the  f_ind-th B-spline of
% space in the dyadically refined space, as shown at pg. 33 of Hollig,
% Finite element methods with B-splines (2003). Only works for B-plines on
% simple knots.
%
%   subdivision_plot(space, bsp_ind)
%
% INPUTS:
%   space:  Bspline_space
%   f_ind:  Index of the function to be subdivided
%
% OUTPUTS:
%
%   New figure with plot of f_ind and its subdivision in the dyadic
%   refinement of space.
%

% p=space.deg;
% spacer=DyadRef(space);


p=space.deg;
Xi=space.knots;

kdx=1;
for jdx=1:numel(Xi)-1
    Xi1(kdx)=Xi(jdx);
    h=Xi(jdx+1)-Xi(jdx);
    Xi1(kdx+1)=Xi(jdx)+h*0.5;
    kdx=kdx+2;
end
spacer=Bspline_space(space.deg,Xi1(p+1:end-p+1));

figure
hold on

t=linspace(space.knots(1),space.knots(end),numel(space.knots)*100);

for ind=f_ind
    plot(t,space.Bspline_eval(ind,t));
    for kdx=0:p+1
        jdx=2*ind+kdx-1;
        b=@(x) (0.5)^(p) * nchoosek(p+1,kdx) * ...
            spacer.Bspline_eval(jdx, x);
        plot(t,b(t))
        
    end
end

end
