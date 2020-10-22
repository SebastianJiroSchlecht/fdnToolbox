% Example for zFilter
% 
% Testing script for the computation of zFilters and verifaction with a
% numerical differentation method.
%
% Sebastian J. Schlecht, Tuesday, 20. October 2020

clear; clc; close all;

rng(2)
nfft = 2^14;

%% Test: Transfer function and derivative
n = 2; % size of filter matrix
m = 1; %
order = 5;
a = randn(n,m,order);
b = randn(n,m,order);

% Frequency response and numerical derivative
[h,w] = freqz( permute(b(1,1,:),[3 1 2]), permute(a(1,1,:),[3 1 2]), nfft);
ww = exp(1i * w);
dh = diff(h) ./ diff(ww);

% Same with zFilter object
z = zTF(b,a,'isDiagonal',true);
[hh,dhh] = probeZFilter(z,ww);

% plot
plotLines(w,h,hh,dh,dhh)

% Direct and numerical estimation
assert(isAlmostZero(abs(h - hh)))
assert(isAlmostZero(abs(dh - dhh(2:end)),'tol',.1))

%% sos
close all;
nsos = 3; % at least 2
n = 2; % size of filter matrix
m = 1; %
sos = rand(n,m,nsos,6);

% Frequency response and numerical derivative
[h,w] = freqz( permute(sos(1,1,:,:),[3 4 1 2]), nfft);
ww = exp(1i * w);
dh = diff(h) ./ diff(ww);

% Same with zFilter object
z = zSOS(sos, 'isDiagonal', false);
[hh,dhh] = probeZFilter(z,ww);

% plot
plotLines(w,h,hh,dh,dhh)

% Direct and numerical estimation
assert(isAlmostZero(abs(h - hh)))
assert(isAlmostZero(abs(dh - dhh(2:end)),'tol',0.1))






function plotLines(w,h,hh,dh,dhh)

figure(1); hold on; grid on;
offset = 0.1;
plot(w,real(h))
plot(w,imag(h))
plot(w,real(hh)+offset)
plot(w,imag(hh)+offset)
legend({'Real Freqz','Imag Freqz', 'Real zFilter','Imag zFilter'})
xlabel('Frequency [rad]')
ylabel('Amplitude [lin]')

figure(2); hold on; grid on;
offset = 0.1;
plot(w(2:end),real(dh))
plot(w(2:end),imag(dh))
plot(w,real(dhh)+offset)
plot(w,imag(dhh)+offset)
legend({'Real Freqz','Imag Freqz', 'Real zFilter','Imag zFilter'})
xlabel('Frequency [rad]')
ylabel('Amplitude [lin]')

end

function [hh,dhh] = probeZFilter(z,ww)
hh = 0*ww;
dhh = 0*ww;
for it = 1:numel(ww)
    mat = z.at( ww(it) );
    hh(it) = mat(1,1);
    
    mat = z.der( ww(it) );
    dhh(it) = mat(1,1);
end
end