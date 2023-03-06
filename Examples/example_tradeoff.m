% Example for FDN Tradeoff
%
% FDN design typically needs to balance modal and echo density with
% computational complexity:
% - the longer the delays, the more modes, but less echo density
% - the more delays, the higher modal and echo density, but more expensive
%
% Schlecht, S. (2020). FDNTB: The Feedback Delay Network Toolbox,
% Proceedings of the 23rd International Conference on Digital Audio Effects
% (DAFx-20)
%
% Sebastian J. Schlecht, Monday, 06 March 2023
clear; clc; close all;

rng(2)
fs = 48000;
irLen = 2*fs;
gainPerSample = db2mag(RT602slope(2,fs));


% We compare 3x3 settings
% delays: short, medium, long
% FDN size: small, medium, large
Ns = [4 8 16];
Ds = round((rand(1,16) + 0.5) .* [300; 1000; 3000]);


% generate impulse responses
for itN = 1:size(Ns,2)
    for itD = 1:size(Ds,1)
        % Define FDN
        N = Ns(itN);
        delays = Ds(itD,1:N);
        numInput = 1;
        numOutput = 1;
        g = diag(gainPerSample.^delays);
        A = fdnMatrixGallery(N,'orthogonal') * g;
        B = ones(N,numInput);
        C = ones(numOutput,N);
        D = zeros(numOutput,numInput);
        
        rir(:,itN,itD) = dss2impz(irLen,delays,A,B,C,D); 

        %audiowrite(sprintf('tradeoff_N%d_D%d.wav',N,round(mean(delays))),0.5*rir(:,itN,itD),fs);
    end
end




%% Test: Script completed
assert( true ) 

