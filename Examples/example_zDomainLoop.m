% Example zDomain matrix and loop types
%
% Sebastian J. Schlecht, Sunday, 29 December 2019
clear; clc; close all;

rng(1)
fs = 48000;
impulseResponseLength = fs;

%% Define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([130 410],[1 N]);

%% Generate absorption filters
RT_DC = 2; % seconds
RT_NY = 0.5; % seconds
[onePole.b,onePole.a] = onePoleAbsorption(RT_DC, RT_NY, delays, fs);
noFilter.b = ones(N,1);
noFilter.a = ones(N,1);

%% zDomain
delayTF = zDomainDelay(delays);

type = 'StableScalarMatrix';
absorption.(type) = noFilter;
feedbackMatrix.(type) = randomOrthogonal(N) * diag(rand(N,1)) * randomOrthogonal(N);
inverseMatrix.(type) = inv(feedbackMatrix.(type));
matrixTF.(type) = zDomainScalarMatrix(feedbackMatrix.(type));
invmatTF.(type) = zDomainScalarMatrix(inverseMatrix.(type));

type = 'ParaunitaryFIRMatrix';
absorption.ParaunitaryFIRMatrix = noFilter;
[feedbackMatrix.(type),inverseMatrix.(type)] = constructCascadedParaunitaryMatrix(N,3,'matrixType','random');
matrixTF.(type) = zDomainMatrix(feedbackMatrix.(type));
invmatTF.(type) = zDomainMatrix(inverseMatrix.(type));

type = 'AbsorptionInMatrix';
absorption.(type) = onePole;
[feedbackMatrix.(type),~] = constructCascadedParaunitaryMatrix(N,2);
numerator = matrixConvolution(feedbackMatrix.(type),polydiag(onePole.b));
denominator = matrixConvolution(ones(N),polydiag(onePole.a));
matrixTF.(type) = zDomainMatrix(numerator,denominator);


%% compute impulse response and poles/zeros
fnames = fieldnames(matrixTF);

for it = 1:length(fnames)
    type = fnames{it};
    irTimeDomain = ss2impz_fdn(impulseResponseLength, delays, matrixTF.(type), inputGain, outputGain, direct);
    [res, pol, directTerm, isConjugatePolePair,metaData] = ss2pr_fdn(delays, matrixTF.(type), inputGain, outputGain, direct);
    irResPol = pr2impz_fdn(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);
    
    difference = irTimeDomain - irResPol;
    fprintf('Maximum devation betwen time-domain and pole-residues is %f\n', permute(max(abs(difference),[],1),[2 3 1]));
    
    %% plot
    close all;
    
    figure(1); hold on; grid on;
    t = 1:size(irTimeDomain,1);
    plot( t, difference(1:end) );
    plot( t, irTimeDomain - 2 );
    plot( t, irResPol - 4 );
    legend('Difference', 'TimeDomain', 'Res Pol')
    
    figure(2); hold on; grid on;
    plot(angle(pol),abs(pol),'x');
    legend({'Poles'})
    xlabel('Pole Angle [rad]')
    ylabel('Pole Magnitude [linear]')
    
    figure(3); hold on; grid on;
    plot(angle(pol),abs(pol),'x');
    plot(angle(metaData.recordPoles),abs(metaData.recordPoles),':o');
    legend({'Poles','Pole Refinement'})
    xlabel('Pole Angle [rad]')
    ylabel('Pole Magnitude [linear]')
end