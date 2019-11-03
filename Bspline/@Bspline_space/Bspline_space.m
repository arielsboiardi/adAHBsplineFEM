classdef Bspline_space
    % Bspline_space contains information necessary to represent a B-spline 
    % space, as illustrated in the report. 
    
    properties
        deg         % B-splines degree
        knots       % Knot vector of the B-splines
        dim         % Dimension of the spanned space
    end
    
    methods
        
        function space=Bspline_space(deg, knots)
            % Constructor of the Bspline_space class
            %
            %   space=Bspline_space(deg, knots)
            %
            % INPUTS:
            %  
            %   deg:    degree of the B-splines
            %   knots:  non-extended knot vector (see report)
            %
            % OUTPUTS:
            %
            %   space:  instance of the class
            %
            
            space.deg=deg;
            reshape(knots,1,numel(knots)); % transform in row 
            space.knots=[knots(1)*ones(1,deg),knots,knots(end)*ones(1,deg)]; % extend knot vector with padding accordin to deg
            space.dim=numel(space.knots)-deg-1; % As computed in the report
        end 

    end
    
end
