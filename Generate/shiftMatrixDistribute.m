function [shiftLeft] = shiftMatrixDistribute( mat, sparsity, varargin )
% Shift in polynomial matrix in time-domain such that they don't overlap
% sparsity = [1,inf] = [dense->sparse]
%
% Sebastian J. Schlecht, Sunday, 29 December 2019

%% Input parser
pp = find_ndim(mat,3,'last');
pulseSize = max(pp(:));

p = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
p.addOptional('pulseSize', pulseSize, validScalarPosNum);
parse(p,varargin{:});

pulseSize = p.Results.pulseSize;

%% Generate random Time Shift
N = size(mat,1);

randLeftShift = floor(sparsity * ((0:N-1) + rand(1,N)*0.99));
shiftLeft = randLeftShift * pulseSize;

