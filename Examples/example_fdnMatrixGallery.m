% Example for fdnMatrixGallery
%
% Collection of matrices for FDN design from various literature
% sources. An overview can be found in 
%
% Schlecht, S. (2020). FDNTB: The Feedback Delay Network Toolbox,
% Proceedings of the 23rd International Conference on Digital Audio Effects
% (DAFx-20)
%
% Sebastian J. Schlecht, Saturday, 28 December 2019
clear; clc; close all;

rng(2)

% Define FDN
N = 8;
numInput = 1;
numOutput = 1;
B = ones(N,numInput);
C = ones(numOutput,N);
D = zeros(numOutput,numInput);
delays = randi([50,100],[1,N]);

% Retrieve all matrix types
matrixTypes = fdnMatrixGallery(); 

%Poles/zeros for all matrix types
for it = 1:length(matrixTypes)
   type = matrixTypes{it};   
   [feedbackMatrix.(type) supposedLossless.(type)] = fdnMatrixGallery(N,type);
   
   [residues, poles.(type), direct, isConjugatePolePair, metaData] = dss2pr(delays,feedbackMatrix.(type),B,C,D);
   
   isLossless.(type) = isAlmostZero( abs(poles.(type)) - 1, 'tol', 10^-10);
end

% Plot
plotWidth = '4.6cm';
plotConfig = {'type','standardSingleColumn','width',plotWidth,'extraAxisOptions',...
    {'yticklabel style={/pgf/number format/fixed,/pgf/number format/precision=5},scaled y ticks=false'}};

for it = 1:length(matrixTypes)
    type = matrixTypes{it};
    figure(it); set(gcf,'color','w');
    plotMatrix(feedbackMatrix.(type))
    caxis([-1 1])
    
    matlab2tikz_sjs(['./Plots/matrix_' type '.tikz'],plotConfig{:})
end

%% Test: Matrices are lossless
c = struct2cell(isLossless);
sc = struct2cell(supposedLossless);
assert( all([c{:}] == [sc{:}]) ) % not all matrices are lossless / some are allpass

