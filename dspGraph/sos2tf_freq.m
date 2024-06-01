function [b,a] = sos2tf_freq(sos)

% sos = [1  1  1  1  0 -1; -2  3  1  1 10  1];

% sos has shape L x 6

L = size(sos,1);

B = sos(:,1:3);
A = sos(:,4:6);

nfft = L*3+1;
BB = fft(B,nfft,2);
BBB = prod(BB,1);
b = ifft(BBB,nfft,2);

AA = fft(A,nfft,2);
AAA = prod(AA,1);
a = ifft(AAA,[],2);

ok = 1;
