% (c) Sebastian Jiro Schlecht:  23. April 2018
% 
% Example of using a first order lowpass filter for frequency-dependent
% reverberation time.
clear; clc; close all;
filename = mfilename;

rng(1)
fs = 48000;
impulseResponseLength = fs;

% FDN definition
N = 4;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = ones(numOutput,numInput);
delays = randi([50, 300]*10,[1,N]);
feedbackMatrix = randomOrthogonal(N);

% Generate absorption filters
RT_DC = 3; % seconds
RT_NY = 0.1; % seconds
crossover_frequency = 12000; % Hz

switch 'firstOrder'
    case 'onePole'
        [absorption.b,absorption.a] = onePoleAbsorption(RT_DC, RT_NY, delays, fs);
    case 'firstOrder'
        [absorption.b,absorption.a] = firstOrderAbsorption(RT_DC, RT_NY, crossover_frequency, delays, fs);
end
zAbsorption = zTF(absorption.b, absorption.a,'isDiagonal', true); 

% compute with absorption
irTimeDomain = dss2impz(impulseResponseLength, delays, feedbackMatrix, inputGain, outputGain, direct, 'absorptionFilters', zAbsorption);
tic
[res, pol, directTerm, isConjugatePolePair, metaData] = dss2pr(delays, feedbackMatrix, inputGain, outputGain, direct, 'DeflationType', 'neighborDeflation', 'absorptionFilters', zAbsorption, 'rejectUnstablePoles', false); % 
toc
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength,'lowMemory');

difference = irTimeDomain - irResPol;

% compute without absorption
[no_res, no_pol, no_directTerm, no_isConjugatePolePair] = dss2pr(delays, feedbackMatrix, inputGain, outputGain, direct, 'DeflationType', 'neighborDeflation');
no_irResPol = pr2impz(no_res, no_pol, no_directTerm, no_isConjugatePolePair, impulseResponseLength,'lowMemory');

% min max bounds
[MinCurve,MaxCurve,w] = poleBoundaries(delays, absorption, feedbackMatrix);
f = w / pi * fs/2;

% plot
figure(1); hold on; grid on;
t = 1:size(difference,1);
plot( t, difference );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol')

figure(2); hold on; grid on;
plot(angle(pol),mag2db(abs(res)),'.','MarkerSize',1);
plot(angle(no_pol),mag2db(abs(no_res)),'.','MarkerSize',1);
legend({'Residues with attenuation','Residues without attenuation'},'Location','southeast')
xlabel('Pole Angular Frequency [rad]')
ylabel('Residue Magnitude [dB]')
% set(gca,'XLim',[0 pi],'YLim',[-120 -70]);

figure(4); hold on; grid on;
plotAxes = plot(angle(pol)/pi*fs/2,slope2RT60(mag2db(abs(pol)), fs),'.','MarkerSize',1);
plot(f,slope2RT60(mag2db(MinCurve),fs));
plot(f,slope2RT60(mag2db(MaxCurve),fs));
xlabel('Pole Frequency [Hz]')
ylabel('Pole RT60 [s]')
set(gca,'YLim',[0 2.2],'XLim',[100 fs/2],'XScale','log');
legend({'Poles with attenuation','Minimum Bound','Maximum Bound'},'Location','northeast')

%% Test: Impulse Response Accuracy
matMax = permute(max(abs(difference(1:end)),[],1),[2 3 1])
assert( isAlmostZero(difference, 'tol', 10^-10 )  )

%% Test: Poles between bounds 
[allBounded, isBounded] = isBoundingCurve(angle(pol),abs(pol),w,MaxCurve + 10^-6,'upper');
assert(allBounded)

[allBounded, isBounded] = isBoundingCurve(angle(pol),abs(pol),w,MinCurve - 10^-6,'lower');
assert(allBounded)
