% Example for losslessMatrixGallery
%
% Sebastian J. Schlecht, Saturday, 28 December 2019
clear; clc; close all;

rng(2)

%% Define FDN
N = 8;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([50,100],[1,N]);

%% Retrieve all matrix types
matrixTypes = losslessMatrixGallery(); 

%% Poles/zeros for all matrix types
for it = 1:length(matrixTypes)
   type = matrixTypes{it};   
   feedbackMatrix.(type) = losslessMatrixGallery(N,type);
end

%% Plot
colorMap = [linspace(1,1,256)', linspace(0,1,256)', linspace(0,1,256)'; ...
            linspace(1,0,256)', linspace(1,0,256)', linspace(1,1,256)'];

plotWidth = '4.6cm';
plotConfig = {'type','standardSingleColumn','width',plotWidth,'extraAxisOptions',...
    {'yticklabel style={/pgf/number format/fixed,/pgf/number format/precision=5},scaled y ticks=false'}};

for it = 1:length(matrixTypes)
    type = matrixTypes{it};
    figure(it); set(gcf,'color','w');
    plotMatrix(feedbackMatrix.(type))
    caxis([-1 1])
    colormap(colorMap);
    
    matlab2tikz_sjs(['./Plots/matrix_' type '.tikz'],plotConfig{:})
end

