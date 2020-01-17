% From: 
% Abel & Huang 2006, "A simple, robust measure of reverberation echo
% density", In: Proc. of the 121st AES Convention, San Francisco
%
% Computes the transition time between early reflections and stochastic
% reverberation based on the assumption that sound pressure in a 
% reverberant field is Gaussian distributed.
%
% t_abel             - mixing time nach Abel & Huang (2006, echo density = 1)
% echo_dens          - echo density vector
% IR                 - impulse response (1 channel only!)
% N                  - window length (must be even number!)
% fs                 - sampling rate
% preDelay           - for onset detection
%
% call:
% [t_abel,echo_dens] = compute_echo(IR, N, fs, preDelay)
%
%
% A. Lindau, L. Kosanke, 2011
% alexander.lindau@tu-berlin.de
% audio communication group
% Technical University of Berlin
%
% Hann window implementation and revised std calculation by Ross Penniman
%-------------------------------------------------------------------------%
function [t_abel,echo_dens] = echoDensity(IR, N, fs, preDelay)

% Threshold of normalized echo density at which to determine "mixing time"
% Abel & Huang (2006) uses a value of 1.
mixingThresh = 1.0;

% preallocate
s           = zeros(1,length(IR));
echo_dens   = zeros(1,length(IR));

wTau = hann(N)';
wTau = wTau ./ sum(wTau);
% figure; plot(wTau);

% Implement hopSize if calculations are too slow
% hopSize = 1; % hop size in samples

halfWin = N/2;

if length(IR) < N
    error('IR shorter than analysis window length (1024 samples). Provide at least an IR of some 100 msec.')
end

sparseInd = 1:500:length(IR);
for n = sparseInd
    % window at the beginning (increasing window length)
    % n = 1 to 513
    if (n <= halfWin+1)
        hTau = IR(1:n+halfWin-1)';
        wT = wTau((end-halfWin-n+2):end);

    % window in the middle (constant window length)
    % n = 514 to end-511
    elseif ((n > halfWin+1) && (n <= length(IR)-halfWin+1))
        hTau = IR((n-halfWin):(n+halfWin-1))';
        wT = wTau;

    % window at the end (decreasing window length)
    % n = (end-511) to end
    elseif (n > length(IR)-halfWin+1)
        hTau = IR(n-halfWin:end)';
        wT = wTau(1:length(hTau));

    else
        error('Invalid n Condition');
    end

    % standard deviation
    s(n) = sqrt(sum(wT.*(hTau.^2)));

    % number of tips outside the standard deviation
    tipCt = (abs(hTau) > s(n)); 

    % echo density
    echo_dens(n) = sum(wT .* tipCt);                                   
end

% normalize echo density
echo_dens = echo_dens ./ erfc(1/sqrt(2));

echo_dens = interp1(sparseInd, echo_dens(sparseInd), 1:length(IR));

% figure; plot(s, 'r');
% title('Std Dev');

% determine mixing time
d           = find(echo_dens > mixingThresh,1,'first');                   
t_abel      = (d - preDelay)/fs * 1000;

if isempty(t_abel)
    t_abel = 0;
    disp('Mixing time not found within given limits.');
end


