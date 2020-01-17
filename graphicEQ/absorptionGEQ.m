function [b,a] = absorptionGEQ(RT, delays, fs)
% absorptionGEQ - Design GEQ absorption filters according to specified T60
%
% Schlecht, S., Habets, E. (2017). Accurate reverberation time control in
% feedback delay networks Proc. Int. Conf. Digital Audio Effects (DAFx)
%
% Syntax:  [b,a] = absorptionGEQ(RT, delays, fs)
%
% Inputs:
%    RT - Reverberation time in [seconds] at ten frequency bands
%    delays - Array of delay times in [samples]
%    fs - Sampling frequency
%
% Outputs:
%    b - Filter numerator
%    a - Filter denominators
%
% Example:
%    [b,a] = absorptionGEQ(ones(10,1), [100, 130], 48000)
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
% 17. January 2020; Last revision: 17. January 2020

%% Initialization
% Setup variables such as sampling frequency, center frequencies and
% control frequencies, and command gains
N = length(delays);
fftLen = 2^16;

centerFrequencies = [ 63, 125, 250, 500, 1000, 2000, 4000, 8000]; % Hz
ShelvingCrossover = [46 11360]; % Hz
numFreq = length(centerFrequencies) + length(ShelvingCrossover);
shelvingOmega = hertz2rad(ShelvingCrossover, fs);
centerOmega = hertz2rad(centerFrequencies, fs);
R = 2.7;


% control frequencies are spaced logarithmically
numControl = 100;
controlFrequencies = round(logspace(log10(1), log10(fs/2.1),numControl+1));

% target magnitude response via command gains
targetF = [1, centerFrequencies fs];
targetG = RT602slope(RT,fs); % dB
targetInterp = interp1(targetF, targetG, controlFrequencies)';

%% desgin prototype of the biquad sections
prototypeGain = 10; % dB
prototypeGainArray = prototypeGain * ones(numFreq+1,1);
prototypeSOS = graphicEQ(centerOmega, shelvingOmega, R, prototypeGainArray);
[G,prototypeH,prototypeW] = probeSOS (prototypeSOS, controlFrequencies, fftLen, fs);
G = G / prototypeGain; % dB vs control frequencies

%% compute optimal parametric EQ gains
% Either you can use a unconstrained linear solver or introduce gain bounds
% at [-20dB,+20dB] with acceptable deviation from the self-similarity
% property. The plot shows the deviation between design curve and actual
% curve.
upperBound = [Inf, 2 * prototypeGain * ones(1,numFreq)];
lowerBound = -upperBound;

for it = 1:N
    optG = lsqlin(G, targetInterp * delays(it), [],[],[],[], lowerBound, upperBound); % TODO: fix optimization
    % optG = G\targetInterp; % unconstrained solution
    optimalSOS = graphicEQ( centerOmega, shelvingOmega, R, optG );
    [b(it,:),a(it,:)] = sos2tf(optimalSOS(2:end,:) ); % TODO fix unstable
end


