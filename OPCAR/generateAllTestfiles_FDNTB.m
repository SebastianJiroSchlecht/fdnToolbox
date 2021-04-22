
% Janis Heldmann, 17. Dec 2020
clear; clc; close all;

filename = 'OPCAR_files';
mkdir(filename)
addpath(filename)
cd(filename)

mkdir('RawIRs')
addpath('RawIRs')
mkdir('plots')
addpath('plots')

rng(1);
fs = 48000;
irLen = 3*fs;
Pink = pinknoise(0.3*fs); % noise burst as input signal
testTypes = {'Reference','NumberOfModes','Rayleigh','FlippedRayleigh','FDNs'};
%testTypes = {'FDNs'}; % or choose specific test

test = testTypes{1}; % initialize test
numberOfModes = 10000;
g = 0.9999; % attenuation per sample

%% innitialize distributions
%static random frequency angles
% generate a random frequency distribution
angle_range = [0,pi];
random_phase_angle = (angle_range(2)-angle_range(1)).*rand(numberOfModes,1) + angle_range(1);

% static random number distribution for inverse transform sampling (Rayleigh)
uniformlyDistributedRandomNumbers = rand(numberOfModes, 1);
randomization = 0.5*fs/numberOfModes/2;
linearDistributedFrequencies = linspace(randomization,0.5*fs-randomization,numberOfModes);
range = [-randomization,randomization];
randomizationOfFrequencies = (range(2)-range(1)).*rand(1,numberOfModes) + range(1);
randomizedDistributedFrequencies = linearDistributedFrequencies + randomizationOfFrequencies;
random_angle = hertz2rad(randomizedDistributedFrequencies,fs);

%% generate reference noise
noise = randn(irLen,1);
s = 1:length(noise);
decayingNoise = (noise'.* g.^(s))';

%% set innitial test parameters
% Test 1: number of modes
TestModes = [500 1500 3000 5000 10000];
direct = 1; % direct gain for pr2impz
% Test 2: Rayleigh scaling factor sigma
Rayleigh_sigma = linspace(0.1,10,5);
% Test 3: flipped Rayleigh scaling factor sigma
FlippedRayleigh_sigma = linspace(0.1,30,5);
% Test 4: FDNs
N = 8; % FDN size
primenDelays = primes(1500); % choose prime number delays
primenDelays(primenDelays > 800);
Spacing = logspace(log10(800),log10(1500),8);
delays = [ 809 877 937 1049 1151 1249 1373 1499]; % primes closest to logspace(log10(800),log10(1500),8)
G = diag( g.^delays ); % diagonal attenuation matrix


if isprime(delays) == 1
    disp('Delays are primenumbers.')
else
    error('Delays are not primenumbers.')
end

%% initialize test sample names

AllTypes.Reference = {'Noise'};
AllTypes.NumberOfModes = {['NumModes',num2str(TestModes(1))],['NumModes',num2str(TestModes(2))],['NumModes',num2str(TestModes(3))],['NumModes',num2str(TestModes(4))],['NumModes',num2str(TestModes(5))]};
AllTypes.Rayleigh = {'Rayleigh1','Rayleigh2','Rayleigh3','Rayleigh4','Rayleigh5'};
AllTypes.FlippedRayleigh = {'FlippedRayleigh1','FlippedRayleigh2','FlippedRayleigh3','FlippedRayleigh4','FlippedRayleigh5'};
AllTypes.FDNs = {'allpassFDN','randomOrthogonal','Hadamard','Householder','SchroederSeriesAllpass'};
idxCount = 0;

for idx =  1:length(testTypes)
    t = AllTypes.(testTypes{idx});
    for idx2 = 1 : length(t)
        allTypes{idxCount+idx2} = t{idx2};
    end
    idxCount = idxCount +idx2;
end

testMax = zeros(size(allTypes)); % initialize peakmaximum vector for normalization

%% Loop through all tests and set additional test parameters

cd('plots') % plots for each test are saved to 'plots' folder

for idx = 1 : length(testTypes)
    close all;
    test = testTypes{idx};
    switch test
        case 'Reference'
            filename = test;
            Types = AllTypes.Reference;
            NumberOfModes.(test) = numberOfModes;
        case 'NumberOfModes'
            NumberOfModes.(test) = TestModes;
            Types = AllTypes.NumberOfModes;
            filename = test;
            gainShift = -60;
        case 'Rayleigh'
            sign = 1;
            gainShift = -73;
            Types = AllTypes.Rayleigh;
            filename = test;
            NumberOfModes.(test) = numberOfModes;
        case 'FlippedRayleigh'
            sign = -1;
            gainShift = -60;
            Types = AllTypes.FlippedRayleigh;
            Rayleigh_sigma = FlippedRayleigh_sigma;
            filename = test;
            NumberOfModes.(test) = numberOfModes;
        case 'FDNs'
            Types = AllTypes.FDNs;
            filename = 'FDNs';
            NumberOfModes.(test) = numberOfModes;
    end
    
    % generate residues and poles of modes
    for it =  1:length(Types)
        type = Types{it};
        
        if  strcmp(test,'Reference')
            ir.(type) = decayingNoise;
            res.(type) = zeros(NumberOfModes.(test)(it),1);
            poles.(type) = zeros(1, NumberOfModes.(test)(it));
            
        elseif  strcmp(test,'NumberOfModes')
            randomization = 0.5*fs/NumberOfModes.(test)(it)/2;
            linearDistributedFrequencies = linspace(randomization,0.5*fs-randomization, NumberOfModes.(test)(it));
            range = [-randomization,randomization];
            randomizationOfFrequencies = (range(2)-range(1)).*rand(1, NumberOfModes.(test)(it)) + range(1);
            randomizedDistributedFrequencies = linearDistributedFrequencies + randomizationOfFrequencies;
            random_angle = hertz2rad(randomizedDistributedFrequencies,fs);
            res.(type) = zeros(NumberOfModes.(test)(it),1);
            poles.(type) = zeros(1, NumberOfModes.(test)(it));
            for j = 1:length(res.(type))
                res.(type)(j) = db2mag(gainShift)*exp(sqrt(-1)*random_phase_angle(j));
                poles.(type)(j) = g*exp(sqrt(-1)*random_angle(j));
            end
            isConjugatePolePair = ones(1,length(poles.(type)));
            ir.(type) = pr2impz(res.(type), poles.(type), direct, isConjugatePolePair, irLen, 'lowMemory');
            
        elseif strcmp(test,'Rayleigh') || strcmp(test,'FlippedRayleigh')
            % FLip the CDF of the Rayleigh function
            sampleFromDistribution = sign*sqrt(-log(1-uniformlyDistributedRandomNumbers)*(2*Rayleigh_sigma(it)^2))+gainShift;
            res.(type) = zeros(NumberOfModes.(test),1);
            poles.(type) = zeros(1, NumberOfModes.(test));
            for j = 1:length(res.(type))
                res.(type)(j) = db2mag(sampleFromDistribution(j))*exp(sqrt(-1)*random_phase_angle(j));
                poles.(type)(j) = g*exp(sqrt(-1)*random_angle(j));
            end
            isConjugatePolePair = ones(1,length(poles.(type)));
            
            ir.(type) = pr2impz(res.(type), poles.(type), direct, isConjugatePolePair, irLen, 'lowMemory');
            
        elseif strcmp(test,'FDNs')
            [A.(type),b.(type),c.(type),d.(type)] = TestFDNMatrixGallery(G,N,type);
            [res.(type), poles.(type), direct, isConjugatePolePair, metaData] = dss2pr(delays,A.(type),b.(type),c.(type),d.(type));
            ir.(type) = dss2impz(irLen, delays, A.(type), b.(type), c.(type), d.(type));
        end
        
        %% Normalize IRs with RMS
        ir.(type)=  ir.(type)/sqrt(mean(ir.(type).^2))/20;
        
        %% Plot for each testtype and save to 'Plots' folder
        figure(1); hold on; grid on;
        time = smp2ms(1:irLen, fs);
        plot(time, ir.(type)+2*(it-1));
        xlabel('Time [ms]')
        ylabel('Level [lin]')
        saveas(gcf,['Ir',test],'fig')
        saveas(gcf,['Ir',test],'png')
        
        figure(2); hold on; grid on;
        plot(0.001.*rad2hertz(angle(poles.(type)),fs),mag2db(abs(res.(type))),'.','MarkerSize',2)
        xlabel('Frequency [kHz]')
        ylabel('Magnitude [dB]')
        axis([0 24 -100 -55])
        legend(Types)
        saveas(gcf,['ModDec',test],'fig')
        saveas(gcf,['ModDec',test],'png')
        
        %       matlab2tikz_sjs(['ModDec.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');
        
        figure(3) ;hold on;grid on;
        [n,edges] = histcounts(mag2db(abs(res.(type))), 'Normalization','pdf');
        edges = edges(2:end) - (edges(2)-edges(1))/2;
        plot([edges(1)-0.1,edges], [0,n],'LineWidth',1);
        ylabel('Probability density')
        xlabel('Magnitude [dB]')
        axis([-140 -20 0 0.2])
        legend(Types)
        
        %       legend({'$\sigma$ = 0.100'    '$\sigma$ = 7.575'   '$\sigma$ = 15.050'   '$\sigma$ = 22.525'   '$\sigma$ = 30.000'},'Position','northwest')
        %       legend({'$\sigma$ = 0.100'    '$\sigma$ = 2.575'   '$\sigma$ = 5.050'   '$\sigma$ = 7.525'   '$\sigma$ = 10.000'})
        
        saveas(gcf,['ResDist',test],'fig')
        saveas(gcf,['ResDist',test],'png')
        
        %       matlab2tikz_sjs(['Distribution.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');
        
        
        
    end
    
    if strcmp(test,'Rayleigh')
        
        figure(3)
        for i = 1 :length(Rayleigh_sigma)
            pd = makedist('Rayleigh','b',Rayleigh_sigma(i));
            x_values = -1000:0.01:1000;
            y = pdf(pd,x_values);
            plot(x_values-70,y,'--','LineWidth',0.5)
        end
    end
end
cd ..
%% calculate the maximal peak of all IRs
for i = 1 : length(allTypes)
    testMax(i) = max(ir.(allTypes{i}));
end
TestMax = max(testMax);

%% normalize and save IRs
for it1 = 1 : length(allTypes)
    irNorm.(allTypes{it1})=  ir.(allTypes{it1})/TestMax;
    irBurst.(allTypes{it1})= conv(irNorm.(allTypes{it1}),Pink);
    
    filename = ['ir',allTypes{it1},'.wav'];
    filename2 = ['irBurst',allTypes{it1},'.wav'];
    
    audiowrite(filename2,irBurst.(allTypes{it1}),fs);
    cd('RawIRs')
    audiowrite(filename,irBurst.(allTypes{it1}),fs);
    cd ..
end

%% plot the feedback matrices
colorMap = [linspace(1,1,256)', linspace(0,1,256)', linspace(0,1,256)'; ...
    linspace(1,0,256)', linspace(1,0,256)', linspace(1,1,256)'];

for it = 1:length(AllTypes.FDNs)
    type = AllTypes.FDNs{it};
    figure(3+it); %set(gcf,'color','w');
    colormap(colorMap);
    gg = diag(G);
    g1 = sym('g', [N,1]);
    AA = subs(A.(type),g1,gg);
    bb = subs(b.(type),g1,gg);
    cc = subs(c.(type),g1,gg);
    dd = subs(d.(type),g1,gg);
    plotSystemMatrix(AA,bb,cc,dd)
    
    % matlab2tikz_sjs(['matrix_' +type +'.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');
end

function [A, b, c, d] = TestFDNMatrixGallery(G,N,matrixType,varargin)
%TestFDNMatrixGallery - Collection of tested FDNs
%
% Syntax:  A = TestFDNMatrixGallery(G,N,matrixType,varargin)
%
rng(4)

%% get Types, when no argument is provided
if nargin == 0
    A = {'AllpassCol', 'StandardOrt','StandardHad','SchroederSeries'};
    return;
end

%% get Matrix
switch matrixType
    case 'allpassFDN'
        P = randAdmissibleHomogeneousAllpass(G, [0.9 0.99]);
        diag(P)
        Q = P*G^2;
        [A, b, c, d,~] = homogeneousAllpassFDN(G, P);
    case 'randomOrthogonal'
        A = randomOrthogonal(N) * G;
        d = 0; b=0.5.*ones(N,1);c=0.5.*ones(1,N);
    case 'Hadamard'
        A = hadamard(N)/sqrt(N) * G;
        d = 0; b=0.5.*ones(N,1);c=0.5.*ones(1,N);
    case 'Householder'
        A = householderMatrix(rand(N,1)) * G;
        d = 0; b=0.5.*ones(N,1);c=0.5.*ones(1,N);
    case 'SchroederSeriesAllpass'
        [A, b, c, d] = seriesAllpass(diag(G));
    otherwise
        error('Not defined');
end
end