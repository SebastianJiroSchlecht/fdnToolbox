function A = AndersonMatrix(N,varargin)
%AndersonMatrix - Generates block circulant orthogonal matrix
% NxN block circulant matrix (only first off-diagonal) consisting of KxK
% matrices of type. 
%
% see Anderson, H., Lin, K., So, C., Lui, S. (2015). Flatter Frequency
% Response from Feedback Delay Network Reverbs Proc. Int. Comput. Music
% Conf. 2015(), 238 - 241.
%
% Syntax:  [A] = AndersonMatrix(N,varargin)
%
% Inputs:
%    N - Size of generated matrix A
%    K - (Optional) size of matrix blocks 
%    type - (Optional) matrix type of blocks
%
% Outputs:
%    A - Generated Matrix
%
% Example: 
%    A = AndersonMatrix(9,3,'circulant')
%    A = AndersonMatrix(8)
%
% Other m-files required: fdnMatrixGallery
%
% See also: fdnMatrixGallery
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 19. April 2020; Last revision: 19. April 2020

%% parse
f = factor(N);
p = inputParser;
p.addOptional('K', f(1), @(x) isnumeric(x) && isscalar(x) && x >= 1 );
p.addOptional('type','Hadamard',@(x) ischar(x) );
parse(p,varargin{:});

K = p.Results.K;
type = p.Results.type;

assert( mod(N,K) == 0, 'N needs to be dividable by K.');

%% generate
numberOfBlocks = N/K;

for it = 1:numberOfBlocks
    M{it} = fdnMatrixGallery(K,type,varargin);
end

A = blkdiag(M{:});
A = circshift(A,K);