function printMatLatex( mat, varargin )
%printMatLatex - print matrix to command line in Latex syntax
%
% Syntax:  printMatLatex( mat )
%
% Inputs:
%    mat - matrix to print
%
% Outputs:
%
% Example: 
%    printMatLatex( randn(3) )
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
p.addParameter('format', '%f', @(x) ischar(x));
parse(p,varargin{:});

format = p.Results.format;

%% print
[m,n] = size(mat);
ff = [repmat([format ' & '],m,n-1), repmat([' ' format ' \\\\ \n'],m,1)].';
ffff = ff(:)';
fprintf(['\\begin{bmatrix} \n' ffff '\\end{bmatrix}\n'], mat.')
