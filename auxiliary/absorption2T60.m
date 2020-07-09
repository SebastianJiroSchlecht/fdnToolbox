function [T60,frequency] = absorption2T60( filterCoefficients, delays, nfft, fs )
%absorption2T60 - Compute T60 from recursive absorption filter with delay
%
% Syntax:  [T60,frequency] = absorption2T60( filterCoefficients, delays, nfft, fs )
%
% Inputs:
%    filterCoefficients - FIR filter coefficients
%    delays - Delays in [samples]
%    nfft - Number of frequency points
%    fs - Sampling frequency
%
% Outputs:
%    T60 - Frequency-dependent reverberation time in [seconds]
%    frequency - Frequency points in [hertz]
%
% Example: 
%    [T60,frequency] = absorption2T60( [0.43;0.43;0.12], 10, 32, 48000 )
%
% Other m-files required: slope2RT60
% Subfunctions: none
% MAT-files required: none
%
% See also: absorptionFilters
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 23 December 2019; Last revision: 23 December 2019

filterLength = length(filterCoefficients);

% [response,frequency] = freqz(filterCoefficients, 1, nfft, fs);

response = fft(filterCoefficients,nfft,1);
frequency = linspace(0,fs,length(response)).';

response = response(1:end/2, :);
frequency = frequency(1:end/2);


totalDelay = delays + filterLength/2;

decayPerSample = mag2db(abs(response)) ./ totalDelay;
T60 = slope2RT60(decayPerSample, fs);
