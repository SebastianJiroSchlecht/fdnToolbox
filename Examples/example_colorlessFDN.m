% Example for FDNs optimized to reduce metallic ringing by improving
% perceptual colorlessness 
% Optimization pipeline at https://github.com/gdalsanto/diff-fdn-colorless
% 
% see "Differentiable Feedback Delay Network for Colorless Reverberation,"
% G Dal Santo, K Prawda, SJ Schlecht, V Välimäki
% 26th International Conference on Digital Audio Effects (DAFx23), 244-251.
%
% Gloria Dal Santo, Wed, 18. Oct 2023

close all; clear all; clc
% relative path to parameters folder
mainDir = fullfile("External", "colorlessFDN");   

%% Parameters

% User parameters
fs = 48000;     % sampling frequnecy in Hz
t60 = 3;        % reverberation time in seconds 
delaySet = 1;   % [1, 2] delay set to use 
N = 8;          % [4, 6, 8, 16] size of FDN
irLen = t60*fs; % length of the impulse response

g = 10^(-3/fs/t60);    % gain per sample from (linear)

%% Construct Opitmized FDN

filename = "param_"+"N"+num2str(N)+"_d"+num2str(delaySet)+".mat";

% load parameters 
load(fullfile(mainDir, filename));

m = double(m);
B = B(:);
D = zeros(1,1); % direct gain
Gamma = diag(g.^m);    % attenuaton matrix
Ag = double(expm(skew(A))*Gamma); % apply attenuation


% generate impulse response
ir = dss2impz(irLen, m, Ag, B, C, D);
soundsc(ir, fs); 
% modal decomposition
[residues, ~, ~, ~, ~] = dss2pr(m, Ag, B, C, D);

% plots
figure(1); hold on; grid on;
plot(linspace(0, irLen, length(ir)), ir); 
xlabel('time (s)'); ylabel('amplitude'); 
title('impulse response')

figure(2); hold on; 
res = db(abs(residues));
res = res - mean(res);
histogram(res,'FaceAlpha',0.1,'BinWidth',1)

%% Compare to parameters at initialization

filename = "param_init_"+"N"+num2str(N)+"_d"+num2str(delaySet)+".mat";

% load parameters 
load(fullfile(mainDir, filename));

m = double(m);
B = B(:);
D = zeros(1,1); % direct gain
Gamma = diag(g.^m);    % attenuaton matrix
Ag = double(expm(skew(A))*Gamma); % apply attenuation

% generate impulse response
ir_init = dss2impz(irLen, m, Ag, B, C, D);
soundsc(ir_init, fs); 
% modal decomposition
[residues, ~, ~, ~, ~] = dss2pr(m, Ag, B, C, D);

% plots
figure(1);
plot(linspace(0, irLen, length(ir)), ir_init);
legend("optim", "init");

figure(2);
res = db(abs(residues));
res = res - mean(res);
histogram(res,'FaceAlpha',0.1,'BinWidth',1)
xlabel('Residue Magnitude (dB)')
ylabel('Number of Modes')
legend("optim", "init");

%% Functions 
function Y = skew(X)
    X = triu(X,1);
    Y = X - transpose(X);
end