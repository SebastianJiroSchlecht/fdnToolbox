% Example for absorption filters in FDN
%
% Given a target T60, an FDN with absorption filters is created such that
% the resulting T60 is equal. The absorption filters are short FIR filters.
% To validate the T60 measurement, also the modal decay is computed.
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;

rng(5)

fs = 48000;
impulseResponseLength = fs*2;

% define FDN
N = 8;
numInput = 1;
numOutput = 1;
inputGain = randn(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([500,2000],[1,N]);
feedbackMatrix = randomOrthogonal(N);

% absorption filters
T60frequency = [46, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 11360]'; % Hz
targetT60 = [2 linspace(2,0.5,8) 0.5]'.^0.3;  % seconds
switch 'graphicEQ'
    case 'FIR'
        filterOrder = 64;
        absorption.b = absorptionFilters([0; T60frequency(2:end-1); fs/2], targetT60*ones(1,N), filterOrder, delays, fs);
        absorption.b = permute(absorption.b,[1 3 2]);
        absorptionFilter = dspParallelFilters(absorption.b);
    case 'onePole'
        [absorption.b,absorption.a] = onePoleAbsorption(targetT60(1), targetT60(end), delays, fs);
        absorptionFilter = dspParallelFilters(absorption.b,absorption.a);
    case 'firstOrder'
        crossover_frequency = 1000;
        [absorption.b,absorption.a] = firstOrderAbsorption(targetT60(1), targetT60(end), crossover_frequency, delays, fs);
        absorptionFilter = dspParallelFilters(absorption.b,absorption.a);
    case 'graphicEQ'
        [sos] = absorptionGEQ(targetT60, delays, fs);
        absorptionFilter = dspParallelSOS(sos);
end

% dsp based
[FDN,F,B,C,D] = makeFDN_dsp(delays, feedbackMatrix, inputGain, outputGain, direct, absorptionFilter);

irTimeDomain = dsp2impz(impulseResponseLength,FDN,'frequency');

switch 'none'
    case 'useModalDecomposition'
        [res, pol, directTerm, isConjugatePolePair,metaData] = dss2pr_dsp(F,B,C,D);
        irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);
    case 'none'
        irResPol = 0*irTimeDomain;
end
% evaluation
difference = irTimeDomain - irResPol;
fprintf('Maximum devation betwen time-domain and pole-residues is %f\n', permute(max(abs(difference),[],1),[2 3 1]));

% reverberation time analysis - approximate RIR with a single slope
fBands = T60frequency(2:end-1); % center bands
nSlopes = 1;
net = DecayFitNetToolbox(nSlopes, fs, fBands);
estimatedT60 = net.estimateParameters(irTimeDomain);

%% plot
figure(1); hold on; grid on;
t = 1:size(irTimeDomain,1);
plot( t, difference(1:end) );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol')


figure(2); hold on; grid on;
plot(T60frequency,targetT60,'LineWidth',2);
plot(fBands,estimatedT60,'LineWidth',2);
% plot(rad2hertz(angle(pol),fs),slope2RT60(mag2db(abs(pol)), fs),'.');
set(gca,'XScale','log');
xlim([50 fs/2]);
xlabel('Frequency [hz]')
ylabel('Pole RT60 [s]')
legend({'Target T60','Estimated T60 Late','Poles'})

%% Test: Impulse Response Error
[isZ, maxVal] = isAlmostZero(difference, 'tol', 10^-4);
assert(isZ)

%% Test: Reverberation Time Accuracy
T60_relativeError = (estimatedT60 ./ targetT60(2:end-1) - 1) * 100; % in %
[isZ, maxVal] = isAlmostZero(abs(T60_relativeError), 'tol', 10); % 10% error
assert( isZ )


