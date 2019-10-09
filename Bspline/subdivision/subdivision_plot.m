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

p=space.deg;
spacer=DyadRef(space);

figure
hold on

t=linspace(space.knots(1),space.knots(end),numel(space.knots)*100);

for ind=f_ind
    plot(t,space.Bspline_eval(ind,t));
    
    for kdx=1:p+2
        if 2*ind+kdx-(p+2) > 0
            b=@(x) 2^(-p) * nchoosek(p+1,kdx-1) * ...
                spacer.Bspline_eval(2*ind+kdx-(p+2), x);
            plot(t,b(t))
        end
    end
    
end
