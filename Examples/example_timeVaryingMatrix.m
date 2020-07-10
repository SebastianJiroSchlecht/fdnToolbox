% Test processing routine of the timeVaryingMatrix with a DC signal
% 
% Sebastian J. Schlecht, Wednesday, 1 January 2020
clear; clc; close all;

rng(1);

% Init DC signal
fs = 48000;
N = 5;
input = zeros(fs,N);
input(:,1) = 1; 

% Time varying matrix
modulationFrequency = 7;
modulationAmplitude = 0.3;
spread = 0.3;

TVmatrix = timeVaryingMatrix(N, modulationFrequency, modulationAmplitude, fs, spread);

% Computation with DC input
output = [];
for it = 1:50
    frame = input(1:1000,:);   
    output = [output;  TVmatrix.filter(frame)];
end

% plot
figure(1); hold on; grid on;
plot((output))
legend({'this'})
xlabel(' ')
ylabel(' ')

%% Test: Script finished
assert(1 == 1)
