% Example of FDN decorrelation analysis
%
% This example is based on ideas of
%     Schlecht, S. J., Fagerström, J. & Välimäki, V. Decorrelation in
%     Feedback Delay Networks. IEEE/ACM Transactions on Audio, Speech and
%     Language Processing. Vol XX, 2023
%
% (c) Jon Fagerström:  Friday, 28. April 2023

clear; clc; close all;
rng(5)
fs = 48000;

%% PARAMS
% define FDN
N = 4; % fdn size
m = randi([300,1000],[1,N]); % delays

% scattering matrix params
sparsity = 3;
numStages = 3;

A = constructVelvetFeedbackMatrix(N,numStages,sparsity);  % feedback matrix 

%% COMPUTE ADJUGATE MATRIX adj(P(z))
% Construct P matrix
P = loopTF(m,A);
adjMat = adjPoly(P,'z^1');

%% CORRELATION ANALYSIS
maxLag = sum(m);
maxCorrelation = maxCorr(adjMat);

% filter upper triangle
x = triu(maxCorrelation,1);
xx = x(:);
xx( abs(xx) < eps ) = [];
xx = abs(xx);

% compute statistics
med = median(abs(xx)) % median correlation metric
IQR = iqr(abs(xx)) % interquantile range
%% PLOT

% Plot1 Adjugate
fig1 = figure(1); fig1.Position = [100 100 500 500];
plotImpulseResponseMatrix([], adjMat);
xlabel('Time (samples)'); ylabel('Sample value');

% Plot2 Inter-Channel Max Correlation Matrix
fig2 = figure(2); fig2.Position = [1000 100 700 600];
plotHeatMap(abs(maxCorrelation), [0 1])
xlabel('ij'); ylabel('kl')


%% Test: Script finished
assert(true)

%% FUNCTIONS
function h = plotHeatMap(matrix, limits)
    dim = size(matrix,1);
    N = sqrt(dim);
    for i = 1:dim
        [a,b] = ind2sub(N, i);
        coordLabel{i} = [num2str(a) num2str(b)];
    end
    h = heatmap(coordLabel, coordLabel,matrix);
    grid on;
    colormap(gray)
    h.ColorLimits = limits; 
    Ax = gca;
end