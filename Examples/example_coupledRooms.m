% Example for coupled rooms with FDN
%
% This example is based on ideas of
%     Das, O., Abel, J. S. & Canfield-Dafilou, E. K. Delay Network
%     Architectures For Room And Coupled Space Modeling. in Proceedings of
%     the 23rdInternational Conference on Digital Audio Effects (DAFx2020)
%     (2020).
%
% (c) Sebastian Jiro Schlecht:  Monday, 7. December 2020
clear; clc; close all;

rng(5)

fs = 48000;
impulseResponseLength = fs*2;

% define FDN
N = 12;
numInput = 1;
numOutput = 2; 
inputGain = [ones(N/2,numInput);zeros(N/2,numInput)]; % source in left room
outputGain = blkdiag(ones(1,N/2),ones(1,N/2)); % play rooms to left and right
direct = zeros(numOutput,numInput);
delays = [randi([300,800],[1,N/2]),randi([1000,3000],[1,N/2])];

% two feedback matrices for the two rooms and a coupling constant
A1 = tinyRotationMatrix(N/2,12);
A2 = tinyRotationMatrix(N/2,12);
coupling = 0.3;

feedbackMatrix = [cos(coupling)*A1, sin(coupling)*sqrtm(A1)*sqrtm(A2);...
                 -sin(coupling)*sqrtm(A2)*sqrtm(A1), cos(coupling)*A2];   



% two sets of absorption filters for dry and reverberant room
centerFrequencies = [ 63, 125, 250, 500, 1000, 2000, 4000, 8000]; % Hz
T60frequency = [1, centerFrequencies fs];
shortT60 = [2; 2; 2.2; 2.3; 2.1; 1.5; 1.1; 0.8; 0.7; 0.7]/4;  % seconds
shortAbsorption = absorptionGEQ(shortT60, delays(1:end/2), fs);
longT60 = [2; 2; 2.2; 2.3; 2.1; 1.5; 1.1; 0.8; 0.7; 0.7]*2;  % seconds
longAbsorption = absorptionGEQ(longT60, delays(end/2+1:end), fs);

absorption = cat(1, shortAbsorption, longAbsorption);

zAbsorption = zSOS(absorption,'isDiagonal',true);


% compute impulse response
irTimeDomain = dss2impz(impulseResponseLength, delays, feedbackMatrix, inputGain, outputGain, direct, 'absorptionFilters', zAbsorption);

% compute poles/zeros
[res, pol, directTerm, isConjugatePolePair,metaData] = dss2pr(delays, feedbackMatrix, inputGain, outputGain, direct, 'absorptionFilters', zAbsorption);


%% plot
figure(1); hold on; grid on;
t = 1:size(irTimeDomain,1);
plot( t, irTimeDomain(:,1) );
plot( t, irTimeDomain(:,2) - 2 );
legend('Short Room', 'Long Room')

 
figure(2); hold on; grid on;
plot(rad2hertz(angle(pol),fs),slope2RT60(mag2db(abs(pol)), fs),'x');
set(gca,'XScale','log');
xlim([50 fs/2]);
xlabel('Frequency [Hz]')
ylabel('Reverberation Time [s]')
legend({'Poles'})

figure(3);
plotMatrix(feedbackMatrix)
caxis([-1 1])
colorbar

%% Test: Script finished
assert(true)



