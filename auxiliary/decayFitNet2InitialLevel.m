function [level, A, N] = decayFitNet2InitialLevel(T, A, N, normalization, fs, rirLen, fBands)
% convert decayFitNet estimation to initial level as used in FDNs
%
% (c) Sebastian J. Schlecht, Saturday, 28 January 2023

% Denormalize the amplitudes of the EDC
A = A .* normalization;
N = N .* normalization;

% Estimate the energy of the octave filters
rirFBands = octaveFiltering([1; zeros(fs,1)], fs, fBands);
bandEnergy = sum(rirFBands.^2,1);

% Cumulative energy is a geometric series of the gain per sample
gainPerSample = db2mag(RT602slope(T, fs));
decayEnergy = 1 ./ (1 - gainPerSample.^2);

% initial level
level = sqrt( A ./ bandEnergy ./ decayEnergy * rirLen);
% there is an offset because, the FDN is not energy normalized
% The rirLen factor is due to the normalization in schroederInt (in DecayFitNet)

end

