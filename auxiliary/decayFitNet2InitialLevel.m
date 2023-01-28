function [level, a_est, n_est] = decayFitNet2InitialLevel(t_est, a_est, n_est, norm_est, fs, impulseResponseLength, fBands)
% convert decayFitNet estimation to initial level as used in FDNs
%
% (c) Sebastian J. Schlecht, Saturday, 28 January 2023

% Denormalize the amplitudes of the EDC
a_est = a_est .* norm_est;
n_est = n_est .* norm_est;

% Estimate the energy of the octave filters
rirFBands = octaveFiltering([1; zeros(fs,1)], fs, fBands);
bandEnergy = sum(rirFBands.^2,1).';

% Cumulative energy is a geometric series of the gain per sample
gainPerSample = db2mag(RT602slope(t_est, fs));
decayEnergy = 1 ./ (1 - gainPerSample.^2);

% initial level
level = pow2db(a_est.' ./ bandEnergy.' * impulseResponseLength ./ decayEnergy.');
% there is an offset because, the FDN is not energy normalized

end

