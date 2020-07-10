function [isBounded, isSmaller] = isBoundingCurve(x_points,y_points,x_curve,y_curve,type)
% TODO

% Sebastian J. Schlecht , Friday, 10 July 2020


y_curveInterp = interp1( x_curve, y_curve, x_points,'spline','extrap');

switch type
    case 'upper'
        isSmaller = y_curveInterp >= y_points;
    case 'lower'
        isSmaller = y_curveInterp <= y_points;
    otherwise
        warning('This case is not defined');
end

isBounded = all(isSmaller);





