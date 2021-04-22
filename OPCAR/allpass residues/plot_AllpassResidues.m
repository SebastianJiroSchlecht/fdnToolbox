% plot allpass residues
% Sebastian J. Schlecht, Saturday, 10. April 2021
clear; clc; close all;

rng(2);

N = 10000;
N2 = N/2;
gamma = 0.9999;
discrepancy = linspace(0,.3,4);

types = {'random','lowDiscrepancy'};

cases = {};
leg = {};
for it = 1:numel(discrepancy)
    d = discrepancy(it);
    pAng = circspace(N).' + 2*pi*d*(2*rand(N,1)-1)/N;
    t = sprintf('LD%d',it);
    p.(t) = gamma .* exp(-1i*pAng);
    z.(t) = 1./p.(t);
    
    [r.(t),p.(t),k.(t)] = zp2rpk(z.(t),p.(t),1);
    
    leg{end + 1} = sprintf('$\\zeta = %2.2f$',d);
    cases{end + 1} = t;
end

% add uniform case
pAng = pi*rand(N2,1);
pAng = [pAng;-pAng];
t = 'uniform';
p.(t) = gamma .* exp(-1i*pAng);
z.(t) = 1./p.(t);
[r.(t),p.(t),k.(t)] = zp2rpk(z.(t),p.(t),1);

leg{end + 1} = sprintf('Uniform');
cases{end + 1} = t;

figure(1); hold on; grid on;
for type = cases
    t = type{1};
    plot(angle(p.(t)),abs(p.(t)),'x')
    plot(angle(z.(t)),abs(z.(t)),'o')
end
xlim([-pi pi])
ylim([0 2])

figure(2); hold on; grid on;
for type = cases
    t = type{1};
    plot(angle(p.(t)),mag2db(abs(r.(t))),'.')
end
xlabel('Frequency')
ylabel('Magnitude')
xlim([-pi pi])
% ylim([0 10])
legend(leg,'Interpreter','latex')

figure(3); hold on; grid on;
for type = cases
    t = type{1};
    [counts,edges] = histcounts(mag2db(abs(r.(t))),-80:1:0,'Normalization','pdf');
    plot(edges(1:end-1),counts);
end
xlim([-80,-40])
ylim([0,0.2])
legend(leg,'Interpreter','latex')
ylabel('Probability density')
xlabel('Magnitude [dB]')

%matlab2tikz_sjs('./plots/AllpassModeDistribution.tikz','type','standardSingleColumn','height','8.6cm','width','8.6cm',...
%    'extraAxisOptions',{'y tick label style={/pgf/number format/.cd,fixed,fixed zerofill,precision=2,/tikz/.cd}'});
