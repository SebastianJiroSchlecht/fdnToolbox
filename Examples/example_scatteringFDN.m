% Example for scattering matrices
%
% Demonstration of different types of scattering matrices including
% 'RandomDense','Velvet','fromElementals','noScatter'. Validation is
% performed with the echo density measure.
%
% Sebastian J. Schlecht, Saturday, 28 December 2019
clear; clc; close all;

fs = 48000;
impulseResponseLength = fs;

% Define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([750,2000],[1,N]);

numStages = 3;
matrixTypes = {'RandomDense','Velvet','fromElementals','noScatter'};

% Impulse response and echo density for all matrix types
for it = 1:length(matrixTypes)
   type = matrixTypes{it};
   switch type
       case 'RandomDense'
           feedbackMatrix = zFIR(constructCascadedParaunitaryMatrix(N,numStages));
       case 'Velvet'
           sparsity = 3;
           feedbackMatrix = zFIR(constructVelvetFeedbackMatrix(N,numStages,sparsity));
       case 'fromElementals'
           feedbackMatrix = zFIR(constructParaunitaryFromElementals(N,N*numStages));
       case 'noScatter'
           feedbackMatrix = zFIR(randomOrthogonal(N));    
   end
   
   irTimeDomain.(type) = dss2impz(impulseResponseLength, delays, feedbackMatrix, inputGain, outputGain, direct);
   [t_abel.(type),echo_dens.(type)] = echoDensity(irTimeDomain.(type), 1024, fs, 0);
   
end

% Plot
figure(1); hold on; grid on;
for it = 1:length(matrixTypes)
   plot( irTimeDomain.(matrixTypes{it}) + it*2);      
end

ax = gca;
ax.ColorOrderIndex = 1;
for it = 1:length(matrixTypes)
   plot( echo_dens.(matrixTypes{it}) + it*2,'--');      
end

legend(matrixTypes)
xlabel('Time [samples]')
ylabel('Amplitude and Echo Density [linear]')


%% Test: Script finished
assert(1 == 1)


