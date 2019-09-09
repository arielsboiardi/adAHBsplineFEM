function plot_base(space)
% Rappresenta la base dello spazio space, varargin contiene le
% impostazioni grafiche come plot di libreria.

t=linspace(space.knots(1),space.knots(end),100*numel(space.knots));
figure
hold on
for kdx=1:space.dim
    plot(t,space.Bspline_eval(kdx,t))
end
end