close all
clear all
clc

numberOfFiles = 11;
names = {'a','b','c','d','e','f','g','h','i','j','k'};
tests = {'NumerOfModes','Rayleigh','FlippedRayleigh','FDNs'};
load('results.mat');

%% plot
figure(1);grid on;
violinplot(results.(tests{1})(:,2:end))
xlabel('Testfile')
ylabel('Degree of colorlessness')
xlabel('Number of modes')
yticks([0 25 50 75 100]);
xticklabels({'1000','3500','6000','10000','20000'})
ylim([-5 105])
title(tests{1})

%%
figure(2);grid on;
violinplot(results.(tests{2})(:,2:end))
xlabel('Rayleigh scaling factor \sigma')
ylabel('Degree of colorlessness')
xticklabels({'0.1','2.575','5.05','7.525','10'})
yticks([0 25 50 75 100]);
ylim([-5 105])
title(tests{2})

%%
figure(3);grid on;
violinplot(results.(tests{3})(:,2:end))
xlabel('Flipped Rayleigh scaling factor \sigma')
ylabel('Degree of colorlessness')
xticklabels({'0.1','7.575','15.05','22.525','30'})
yticks([0 25 50 75 100]);
ylim([-5 105])
title(tests{3})

%%
figure(4);grid on;
violinplot(results.(tests{4})(:,2:end))
axis = [0 5 0 100];
xlabel('FDN type')
ylabel('Degree of colorlessness')
xticklabels({'Allpass ','random-orthogonal ','Hadamard ','Householder ','Schroeder Series '});
yticks([0 25 50 75 100]);
ylim([-5 105])
title(tests{4})
