function deg = polyDegree(polynomial,var,varargin)
%polyDegree - Polynomial Degree of polynomial with tolerance and exponent
%sign
%
% Syntax:  deg = polyDegree(polynomial,var,varargin)
%
% Inputs:
%    polynomial - Vector of polynomial coefficients
%    var - Either 'z^1' or 'z^-1'
%    tol (optional) - Tolerance in dB
%
% Outputs:
%    deg - Degree of the polynomial
%
% Example: 
%    polyDegree(randn(10,1),'z^-1')
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 29 December 2019; Last revision: 29 December 2019


%% Input parser
p = inputParser;
validScalarNegNum = @(x) isnumeric(x) && isscalar(x) && (x < 0);
p.addOptional('tol',mag2db(eps),validScalarNegNum);
parse(p,varargin{:});

tol = p.Results.tol; % in dB from maximum coefficient

%% Find last non-zero
polyDB = mag2db(abs(polynomial));
maxCoefficient = max(polyDB);

switch var
    case 'z^-1'
        deg = find( (polyDB - maxCoefficient) > tol, 1, 'last') - 1;
    case 'z^1'
        deg = length(polynomial)-find( (polyDB - maxCoefficient) > tol, 1, 'first');
    otherwise
        error('Not defined');
end