% Sebastian J. Schlecht, Tuesday, 27. February 2024
%
% This is demonstration on how to compute the mode shapes of an FDN.
%
% see Schlecht et al. (2024). Modal Excitation in Feedback Delay Networks (submitted)


clear; clc; close all;

rng(1);

%% Define FDN
N = 3;
m = [13 19 23];
g = 0.98;
A = randomOrthogonal(N) * diag(g.^m);
b = ones(N,1);
c = ones(1,N);
d = zeros(1,1);

%% Modal decomposition of FDN
[residues, poles, direct, isConjugatePolePair, metaData] = dss2pr(m,A,b,c,d);
numModes = numel(poles);

eigenvectors = metaData.eigenvectors;
rv = eigenvectors.right;
lv = eigenvectors.left;

%% Test residue match
res_compact = (lv' * b ) .* (c * rv).';
max(abs([residues - res_compact])) % residues match


%% For plotting only
% check impulse response
irLen = 1000;
ir_impz = dss2impz(irLen,m,A,b,c,d);
ir_pr = pr2impz(res_compact, poles, direct, isConjugatePolePair,irLen);

% expand eigenvalues across delay lines by multiplying the eigenvalue
for it = 1:N
    RV{it} = rv(it,:) .* poles.'.^((0:m(it)-1)).';
    LV{it} = lv(it,:) .* conj(poles.').^((m(it)-1):-1:0).';
end

%% Plot
figure; hold on; grid on;
plot(ir_impz)
plot(ir_pr+1)
legend('Impulse response (time-domain)','IR pole residue')
xlabel('Time (samples)')
ylabel('Impulse response value');

% plot all Eigenvectors
figure; hold on;
RVs = vertcat(RV{:});
plotMatrix(real(RVs))
plot3([1,numModes+1],[1 1]*0+1,[100,100],'-k','LineWidth',3);
plot3([1,numModes+1],[1 1]*m(1)+1,[100,100],'-k','LineWidth',3);
plot3([1,numModes+1],[1 1]*sum(m([1 2]))+1,[100,100],'-k','LineWidth',3);
% colorbar
xlabel('Eigenvalue index $i$');
ylabel('State space index');
xlim([1 numModes+1])
ylim([1 numModes*2])

figure; hold on;
plotMatrix(real(rv))
% plot separating lines
plot3([1,numModes+1],[1 1]*1,[100,100],'-k','LineWidth',3);
plot3([1,numModes+1],[1 1]*2,[100,100],'-k','LineWidth',3);
plot3([1,numModes+1],[1 1]*3,[100,100],'-k','LineWidth',3);
colorbar('horiz')
% xlabel('Eigenvalue index $i$');
ylabel('Delay index');
xlim([1 numModes+1])
ylim([1 N+1])

