function printMatSyntax( mat )
%printMatSyntax - print matrix to command line in code syntax
%
% Syntax:  printMatSyntax( mat )
%
% Inputs:
%    mat - matrix to print
%
% Outputs:
%
% Example: 
%    printMatSyntax( randn(3) )
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


[m,n] = size(mat);
ff = repmat('%f ',m,n);
fff = [ff, repmat(';', m,1)]';
ffff = fff(:)';
fprintf(['[' ffff ']\n'], mat.')
