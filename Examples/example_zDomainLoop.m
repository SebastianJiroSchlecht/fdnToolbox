% Example zDomain matrix and loop types
%
% Demonstrates different matrix types in the FDN processing including
% scalar matrix, absorption matrix and paraunitary (polynomial) matrix.
%
% Sebastian J. Schlecht, Sunday, 29 December 2019
clear; clc; close all;

rng(1)
fs = 48000;
impulseResponseLength = fs;

% Define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([130 410],[1 N]);

% Generate absorption filters
RT_DC = 2; % seconds
RT_NY = 0.5; % seconds
[onePole.b,onePole.a] = onePoleAbsorption(RT_DC, RT_NY, delays, fs);
noFilter.b = ones(N,1);
noFilter.a = ones(N,1);

% zDomain
delayTF = zDomainDelay(delays);

type = 'StableScalarMatrix';
absorption.(type) = noFilter;
feedbackMatrix.(type) = randomOrthogonal(N) * diag(rand(N,1)) * randomOrthogonal(N);
inverseMatrix.(type) = inv(feedbackMatrix.(type));
matrixTF.(type) = feedbackMatrix.(type);
% invmatTF.(type) = inverseMatrix.(type);

type = 'ParaunitaryFIRMatrix';
absorption.ParaunitaryFIRMatrix = noFilter;
[feedbackMatrix.(type),inverseMatrix.(type)] = constructCascadedParaunitaryMatrix(N,3,'matrixType','random');
matrixTF.(type) = feedbackMatrix.(type);
% invmatTF.(type) = inverseMatrix.(type);

type = 'AbsorptionInMatrix';
absorption.(type) = onePole;
[feedbackMatrix.(type),~] = constructCascadedParaunitaryMatrix(N,2);
numerator = matrixConvolution(feedbackMatrix.(type),polydiag(onePole.b));
denominator = matrixConvolution(ones(N),polydiag(onePole.a));
matrixTF.(type) = zTF(numerator,denominator);
% TODO this case does not work

% compute impulse response and poles/zeros
fnames = fieldnames(matrixTF);

%% Test: Impulse Response Accuracy
for it = 2:length(fnames)
    type = fnames{it};
    irTimeDomain = dss2impz(impulseResponseLength, delays, matrixTF.(type), inputGain, outputGain, direct);
    [res, pol, directTerm, isConjugatePolePair,metaData] = dss2pr(delays, matrixTF.(type), inputGain, outputGain, direct);
    irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);
    
    difference = irTimeDomain - irResPol;
    fprintf('Maximum devation betwen time-domain and pole-residues is %f\n', permute(max(abs(difference),[],1),[2 3 1]));
    
    assert(isAlmostZero(difference,'tol',10^0)) % TODO bad due to extra filters
    
    % plot
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



