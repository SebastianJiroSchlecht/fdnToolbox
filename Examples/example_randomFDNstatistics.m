% Example for random FDN statistics
%
% Statistics of a modal decomposition of a random FDN. The pole angles are
% almost equidistributed. The residues magnitudes are spread across a large
% range.
%
% see Schlecht, S., Habets, E. (2019). Modal Decomposition of Feedback
% Delay Networks IEEE Transactions on Signal Processing  67(20), 5340-5351.
% https://dx.doi.org/10.1109/tsp.2019.2937286
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;

rng(3)
fs = 48000;
impulseResponseLength = fs/2;

% Define FDN
N = 8;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = randn(numOutput,numInput);
delays = randi([500,2000],[1,N]);

feedbackMatrix = randomOrthogonal(N); 
% feedbackMatrix = hadamard(N)/sqrt(N); 

% Modal decomposition
irTimeDomain = dss2impz(impulseResponseLength, delays, feedbackMatrix, inputGain, outputGain, direct);

[res, pol, directTerm, isConjugatePolePair, metaData] = dss2pr(delays, feedbackMatrix, inputGain, outputGain, direct);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength,'fast');

difference = irTimeDomain - irResPol;
maximumDeviationOfImpulseResponse = permute(max(abs(difference),[],1),[2 3 1])

% plot
close all;

figure(1); hold on; grid on;
difference = irTimeDomain - irResPol;
t = 1:size(difference,1);
plot( t(1:end), difference(1:end) );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol')

figure(2); hold on; grid on;
edges = linspace(0,pi,400);
[occurences,edges] = histcounts(angle(pol),edges,'Normalization','pdf'); 
bar(edges(2:end),occurences );
ylabel('Likelihood of Occurence')
xlabel('Pole Angle [rad]')
xlim([0,pi])

figure(3); hold on; grid on;
edges = -120:1:40;
for itOut = 1:numOutput
    for itIn = 1:numInput
       [occurences,edges] = histcounts(mag2db(abs(res(:,itOut,itIn)./metaData.undrivenResidues)),edges,'Normalization','pdf') ;
       p3 = plot(edges(2:end),occurences,'k:');
    end
end
[occurences,edges] = histcounts(mag2db(abs(res)),edges,'Normalization','pdf'); 
p1 = plot(edges(2:end),occurences,'LineWidth',2 );

[occurences,edges] = histcounts(mag2db(abs(metaData.undrivenResidues)),edges,'Normalization','pdf'); 
p2 = plot(edges(2:end),occurences,'LineWidth',2);

legend([p3,p1,p2],{'Input-Output Drives','Total Res','Undriven Res'})
ylabel('Likelihood of Occurence')
xlabel('Residue Magnitude [dB]')

%% Test: Script finished
assert(1 == 1);



