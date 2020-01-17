function [G,H,W] = probeSOS (SOS, controlFrequencies, fftLen, fs)
% Probe the frequency / magnitude response of a cascaded SOS filter at the points
% specified by the control frequencies
%
% Author: Sebastian J Schlecht
% Date: 24.03.2017


numFreq = size(SOS, 1);

H = zeros(fftLen, numFreq);
W = zeros(fftLen, numFreq);
G = zeros(length(controlFrequencies), numFreq);


for band = 1:numFreq
    
    b = SOS(band, 1:3);
    a = SOS(band, 4:6);
    
    [h,w] = freqz(b,a,fftLen,fs);
    
    g = interp1(w,mag2db(abs(h)),controlFrequencies);
    
    G(:,band) = g;
    H(:,band) = h;
    W(:,band) = w;
end