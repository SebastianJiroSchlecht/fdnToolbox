function [allBounded, isBounded] = isBoundingCurve(x_points,y_points,x_curve,y_curve,type)
%isBoundingCurve - are all value points bounded by the curve
% The curve is inter/extrapolated with splines at the x-axis points of the
% data points and then compared with the data points.
%
% Syntax:  [isBounded, isSmaller] = isBoundingCurve(x_points,y_points,x_curve,y_curve,type)
%
% Inputs:
%    x_points - xCoordinate of data points
%    y_points - yCoordinate of data points
%    x_curve - xCoordinate of curve points
%    y_curve - yCoordinate of curve points
%    type - curve is 'upper' / 'lower' bound
%
%
% Outputs:
%    allBounded - Logical Value whether all data points are bounded
%    isBounded - Logical values whether data point is bounded
%
% Example: 
%    [allBounded, isBounded] = isBoundingCurve(rand(10,1),rand(10,1),[0,1],ones(1,2),'upper')
%
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 10 July 2020; Last revision: 10 July 2020

% Sebastian J. Schlecht , Friday, 10 July 2020


y_curveInterp = interp1( x_curve, y_curve, x_points,'spline','extrap');

switch type
    case 'upper'
        isBounded = y_curveInterp >= y_points;
    case 'lower'
        isBounded = y_curveInterp <= y_points;
    otherwise
        warning('This case is not defined');
end

allBounded = all(isBounded);





