
function maxCorrMatrix = maxCorr(signals)
% maxCorr - computes maximum cross correlation 
% between all pairwise permutations of a MIMO FDN
% Author: Jon Fagerström
% Updated: 20.10.2022
%   Inputs
%       signals - matrix of signals
%
%   Outputs
%       maxCorrMatrix - pairwise maximum correlation matrix



N = size(signals,[1,2]); % matrix size
numSignals = prod(N);  % number of signals
signals = reshape(permute(signals,[3 1 2]),[],numSignals); % reshape the signal matrix into a vector of signals
maxCorrMatrix = zeros(numSignals,numSignals);
for i = 1:numSignals % For N >= 16 use parfor instead
    for j = 1:numSignals
        corr = xcorr(signals(:,i), signals(:,j), 'normalized'); % compute the cross-correlation
        [maxCorrMatrix(i,j), lagAtMax] = max(abs(corr)); % find the maximum correlation
        maxCorrMatrix(i,j) = maxCorrMatrix(i,j) * sign(corr(lagAtMax)); % reintroduce the sign of the max corr
    end
end
end


